{lib, ...}: let
  inherit (lib) mkDefault;
in {
  boot = {
    loader = {
      systemd-boot = {
        enable = mkDefault true;
        consoleMode = "max";
        editor = false;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = mkDefault true;
      # boot the default entry straight away, hold a key during the loader to
      # get the menu (rollback etc)
      timeout = mkDefault 0;
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
        "usb_storage"
      ];
      kernelModules = [
        "nvme"
        "xhci_pci"
        "btrfs"
        "sd_mod"
        "usbhid"
      ];
    };
  };
}
