{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./file-system.nix
    ./hardware.nix
  ];

  ooknet = {
    host = {
      admin = {
        name = "ooks";
        shell = "fish";
        homeManager = true;
      };
    };
    workstation = {
      environment = "hyprland";
      theme = "minimal";
      default.terminal = "foot";
    };
    console = {
      profile = "standard";
    };
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["fbcon=rotate:1"];
    initrd.availableKernelModules = ["battery" "sdhci_pci"];
  };
  services = {
    tlp.enable = true;
    upower.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    logind.HandleLidSwitch = "suspend";
  };
  powerManagement.powertop.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  system.stateVersion = lib.mkDefault "23.11";
}
