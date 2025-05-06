{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) path int str bool nullOr elem enum;
  inherit (config.ooknet) host;
  inherit (config.ooknet) workstation;
  inherit (config.ooknet.host) admin;
  cfg = config.ooknet.virtualization;
in {
  options.ooknet.virtualization = {
    guest = {
      enable = mkOption {
        type = bool;
        default = host.type == "vm";
        description = "Enable ooknet vm module";
      };
      type = mkOption {
        type = nullOr (enum ["qemu" "vmware" "hyperv"]);
        description = "The type of virtualization to configure for";
        default = null;
      };
    };

    host = {
      enable = mkOption {
        type = bool;
        default = elem "virtualization" workstation.profiles;
        description = "Enable ooknet vm module";
      };
      virt-manager.enable = mkEnableOption "Enable libvirtd graphical front end virt-manager";

      ooknet-install-vm = let
        inherit (self.nixosConfigurations.ooksinstall.config.image) filePath;
        iso = self.images.ooksinstall;
      in {
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
          default = cfg.host.ooknet-install-vm.network.ipRange.start;
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
  };
}
