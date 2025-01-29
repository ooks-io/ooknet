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
      syncthing.enable = true;
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
        terminal = "ghostty";
      };
      # FIXME
      programs.ollama.enable = false;
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
