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
      syncthing.enable = true;
      admin = {
        name = "ooks";
        shell = "fish";
        homeManager = true;
      };
    };
    workstation = {
      silentBoot.enable = true;
      profiles = ["media" "communication"];
      environment = "hyprland";
      theme = "minimal";
    };
    console = {
      profile = "standard";
    };
  };
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  system.stateVersion = lib.mkDefault "23.11";
}
