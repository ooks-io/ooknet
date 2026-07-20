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
  # power management, cpu microcode and intel gpu stack now come from the
  # battery feature + cpu.type/gpu.type in hardware.nix
  system.stateVersion = lib.mkDefault "23.11";
}
