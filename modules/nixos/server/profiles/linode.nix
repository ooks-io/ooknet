{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mkForce mkIf;
  inherit (config.ooknet.server) profile;
in {
  config = mkIf (profile == "linode") {
    networking = {
      tempAddresses = "disabled";
      usePredictableInterfaceNames = mkForce false;
      interfaces.eth0 = {
        tempAddress = "disabled";
        useDHCP = true;
      };
    };

    boot = {
      kernelModules = [];
      # LISH console support
      kernelParams = ["console=ttys0,19200n8"];
      extraModulePackages = [];
      initrd = {
        availableKernelModules = ["virtio_pci" "virtio_scsi" "ahci" "sd_mod"];
        kernelModules = [];
      };
      loader = {
        grub = {
          enable = true;
          device = "/dev/sda";
          forceInstall = true;
          copyKernels = true;
          fsIdentifier = "provided";
          extraConfig = ''
            serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
            terminal_input serial;
            terminal_output serial
          '';
        };
        # disable base settings
        efi.canTouchEfiVariables = mkForce false;
        systemd-boot.enable = mkForce false;
      };
    };

    environment.systemPackages = attrValues {
      inherit
        (pkgs)
        inetutils
        mtr
        sysstat
        linode-cli
        ;
    };
  };
}
