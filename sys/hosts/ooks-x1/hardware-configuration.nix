{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/db84a41f-6094-46b1-b98a-26e03afc18e1";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/3ea21f10-f705-457c-8366-a8268f658ba6";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/db84a41f-6094-46b1-b98a-26e03afc18e1";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/db84a41f-6094-46b1-b98a-26e03afc18e1";
      fsType = "btrfs";
      options = [ "subvol=persist" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/db84a41f-6094-46b1-b98a-26e03afc18e1";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/45D8-8DC3";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 8196;
  }];


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwp0s20f0u2c2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
