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
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "nvme"
        "xhci_pci"
        "btrfs"
        "sd_mod"
      ];
    };
  };
}
