{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  inherit (builtins) toFile;
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) path string int;
  inherit (self.nixosConfigurations.ooksinstall.config.image) filePath;
  inherit (config.ooknet.host) admin;
  iso = self.images.ooksinstall;
  checkSudo =
    if config.virtualisation.libvirtd.qemu.runAsRoot
    then ''
      if [ "$EUID" -ne 0 ]; then
        log error "Sudo not provided: set 'virtualisation.libvirtd.qemu.runAsRoot = false;' to use without sudo."
        exit 1
      fi
    ''
    else "";
  networkConfig = toFile "ooknet-install-network.xml" ''
    <network>
      <name>${cfg.network.name}</name>
      <bridge name='${cfg.network.bridgeName}' stp='on' delay='0'/>
      <forward mode='nat'/>
      <ip address='${cfg.network.ip}' netmask='255.255.255.0'>
        <dhcp>
          <range start='${cfg.network.ipRange.start}' end='${cfg.network.ipRange.end}'/>
          <host mac='${cfg.macAddress}' name='${cfg.name}' ip='${cfg.ipAddress}'/>
        </dhcp>
      </ip>
    </network>
  '';
  cfg = config.ooknet.virtualization.ooknet-install-vm;
in {
  options.ooknet.virtualization = {
    ooknet-install-vm = {
      enable = mkEnableOption "Enable virtual installation testing environment";
      isoPath = mkOption {
        type = path;
        default = "${iso}/${filePath}";
        description = "Path to iso to use";
      };
      name = mkOption {
        type = string;
        default = "ooknet-install-test";
        description = "Name of virtual machine";
      };
      user = mkOption {
        type = string;
        default = admin.name;
        description = "SSH user to connect to virtual machine";
        example = "root";
      };
      macAddress = mkOption {
        type = string;
        default = "52:55:00:11:22:33";
      };
      ipAddress = mkOption {
        type = string;
        default = cfg.network.ipRange.start;
        description = "IP address to assign to the virtual machine";
      };
      ram = mkOption {
        type = int;
        default = 2048;
        description = "Amount of RAM to assign to the virtual machine";
        example = 2048;
      };
      vcpus = mkOption {
        type = int;
        default = 2;
        description = "Amount of cores to assign to the virtual machine";
        example = 4;
      };
      storage = mkOption {
        type = int;
        default = 10;
        description = "Amount in GB of storage to assign to the virtual machine";
        example = 10;
      };
      network = {
        name = mkOption {
          type = string;
          default = "ooknet-install-network";
          description = "Name of virtual network";
        };
        bridgeName = mkOption {
          type = string;
          default = "virbr1";
          description = "Name of virtual network bridge";
        };
        ip = mkOption {
          type = string;
          default = "192.168.150.1";
        };
        ipRange = {
          start = mkOption {
            type = string;
            default = "192.168.150.2";
          };
          end = mkOption {
            type = string;
            default = "192.168.150.2";
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "ooknet-test-vm";
        runtimeInputs = [
          pkgs.gum
        ];
        text = ''
          set -e

          log() {
            local type="$1"
            local message="$2"
            gum log --structured --level "$type" "$message"
          }

          ${checkSudo}

          NAME=${cfg.name}
          IMAGE_PATH="/var/lib/libvirt/images/$NAME.img"

          buildVM() {
            log info "Setting up virtual network..."
            if ! virsh net-info ${cfg.network.name} >/dev/null 2>&1; then
              virsh net-define ${networkConfig} >/dev/null
              log info "Network defined..."
            else
              log warn "Network was already defined..."
              destroyNetwork
              virsh net-define ${networkConfig} >/dev/null
            fi
            virsh net-start ${cfg.network.name} >/dev/null || true
            log info "Network started..."

            log info "Building $NAME VM..."
            gum spin --spinner dot --title "Installing VM..." -- \
            virt-install \
              -n "$NAME" \
              --ram=${toString cfg.ram} \
              --vcpus=${toString cfg.vcpus} \
              --disk path="$IMAGE_PATH",bus=virtio,size=${toString cfg.storage} \
              --graphics none \
              --cdrom ${cfg.isoPath} \
              --network network=${cfg.network.name},mac=${cfg.macAddress} \
              --noautoconsole;
          }

          destroyNetwork() {
            virsh net-destroy ${cfg.network.name}
            log info "Network destroyed";
            virsh net-undefine ${cfg.network.name}
            log info "Network undefined"
          }

          destroyVM() {
            log warn "Shutting VM down..."
            virsh destroy "$NAME" >/dev/null || true
            log warn "Deleting VM..."
            virsh undefine "$NAME" --remove-all-storage >/dev/null
            log info "VM successfully removed..."
          }

          gum log --structured --level info "Checking if image already exists..."

          if virsh list --all | grep -q "\b$NAME\b"; then
            log info "$NAME VM Found:"
            if gum confirm "Remove existing $NAME VM?"; then
              destroyVM
              buildVM
            else
              log info "Aborting VM creation..."
              exit 0
            fi
          elif [ -f "$IMAGE_PATH" ]; then
            log warn "Disk Image for '$NAME' exists without VM"
            if gum confirm "Would you like to remove the orphaned disk?"; then
              rm -f "$IMAGE_PATH"
              buildVM
            else
              log error "Cannot create VM while orphaned disk exists"
              exit 1
            fi
          else
            buildVM
          fi

          log info "VM successfully created"
          log info "Connect with: ssh ${cfg.user}@${cfg.ipAddress}"
        '';
      })
    ];
  };
}
