{
  lib,
  pkgs,
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
      profiles = ["creative" "virtualization" "gaming" "media" "communication" "productivity"];
      default = {
        browser = "firefox";
        terminal = "foot";
      };
    };
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  system.stateVersion = lib.mkDefault "24.11";
}
