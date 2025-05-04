{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  inherit (builtins) toFile;
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) path str int;
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
        type = str;
        default = "ooknet-install-test";
        description = "Name of virtual machine";
      };
      user = mkOption {
        type = str;
        default = admin.name;
        description = "SSH user to connect to virtual machine";
        example = "root";
      };
      macAddress = mkOption {
        type = str;
        default = "52:55:00:11:22:33";
      };
      ipAddress = mkOption {
        type = str;
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
          type = str;
          default = "ooknet-install-network";
          description = "Name of virtual network";
        };
        bridgeName = mkOption {
          type = str;
          default = "virbr1";
          description = "Name of virtual network bridge";
        };
        ip = mkOption {
          type = str;
          default = "192.168.150.1";
        };
        ipRange = {
          start = mkOption {
            type = str;
            default = "192.168.150.2";
          };
          end = mkOption {
            type = str;
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
            if virsh net-info ${cfg.network.name} >/dev/null 2>&1; then
              log info "Network already exists, ensuring it's started..."
              virsh net-start ${cfg.network.name} >/dev/null 2>&1 || true
            else
              log info "Creating network..."
              virsh net-define ${networkConfig} >/dev/null
              virsh net-start ${cfg.network.name} >/dev/null || true
              log info "Network created and started..."
            fi

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
              --noautoconsole
            log info "VM successfully created"
            log info "Connect with: ssh ${cfg.user}@${cfg.ipAddress}"

          }

          destroyNetwork() {
            if virsh net-info ${cfg.network.name} >/dev/null 2>&1; then
              local net_state
              net_state=$(virsh net-info ${cfg.network.name} | grep "Active:" | awk '{print $2}')

              if [ "$net_state" = "yes" ]; then
                virsh net-destroy ${cfg.network.name} >/dev/null
                log info "Network destroyed..."
              else
                log info "Network already stopped..."
              fi

              virsh net-undefine ${cfg.network.name} >/dev/null
              log info "Network undefined..."
            else
              log info "Network not found..."
            fi
          }

          destroyVM() {
            if virsh list --all | grep -q "\b$NAME\b"; then
              local vm_state
              vm_state=$(virsh domstate "$NAME" 2>/dev/null || echo "unknown")

              case "$vm_state" in
                "running")
                  log warn "Shutting VM down..."
                  virsh destroy "$NAME" >/dev/null || true
                  ;;
                "paused")
                  log warn "Stopping Paused VM..."
                  virsh destroy "$NAME" >/dev/null || true
                  ;;
                "shut off")
                  log info "VM already shut off..."
                  ;;
                *)
                  log warn "VM in unknown state: $vm_state"
                  virsh destroy "$NAME" >/dev/null || true
                  ;;
              esac

              if virsh dominfo "$NAME" | grep -q "Managed save:.*yes"; then
                log info "Removing managed save state..."
                virsh managedsave-remove "$NAME"
              fi

              log warn "Deleting VM..."
              if ! virsh undefine "$NAME" --remove-all-storage >/dev/null 2>&1; then
                log warn "Standard undefine failed, removing manually..."

                virsh undefine "$NAME" >/dev/null 2>&1 || true

                if [ -f "$IMAGE_PATH" ]; then
                  log info "Manually removing disk image..."
                  rm -f "$IMAGE_PATH"
                fi
              fi
            else
              log warn "VM not found..."
            fi

            log info "VM successfully removed..."
          }

          startVM() {
            local vm_state
            vm_state=$(virsh domstate "$NAME" 2>/dev/null || echo "unknown")

            case "$vm_state" in
              "running")
                log info "VM is already running..."
                ;;
              "paused")
                log info "Resuming paused VM..."
                virsh resume "$NAME" >/dev/null
                ;;
              "shut off")
                log info "Starting VM..."
                virsh start "$NAME" >/dev/null
                ;;
              *)
                log warn "VM in unknown state: $vm_state"
                ;;
            esac
          }

          log info "Checking if VM exists..."

          if virsh list --all | grep -q "\b$NAME\b"; then
            log info "$NAME VM Found:"

            choice=$(gum choose --no-show-help --selected="Start" "Start" "Delete" "Build New" "Cancel")

            case "$choice" in
              "Delete")
                destroyVM
                destroyNetwork
                ;;
              "Build New")
                destroyVM
                destroyNetwork
                buildVM
                ;;
              "Start")
                startVM

                if virsh net-info ${cfg.network.name} >/dev/null 2>&1; then
                  net_state=$(virsh net-info ${cfg.network.name} | grep "Active:" | awk '{print $2}')

                  if [ "$net_state" != "yes" ]; then
                    log info "Starting network..."
                    virsh net-start ${cfg.network.name} >/dev/null || true
                  fi
                else
                  log warn "Network not found, creating..."
                  virsh net-define ${networkConfig} >/dev/null
                  virsh net-start ${cfg.network.name} >/dev/null || true
                fi
                ;;
              "Cancel")
                log info "Operation cancelled..."
                exit 0
                ;;
            esac
          elif [ -f "$IMAGE_PATH" ]; then
            log warn "Disk Image for '$NAME' exists without VM"
            if gum confirm "Would you like to remove the orphaned disk?"; then
              rm -f "$IMAGE_PATH"
              buildVM
            else
              log error "Cannor create VM while orphaned disk exists"
              exit 1
            fi
          else
            buildVM
          fi


        '';
      })
    ];
  };
}
