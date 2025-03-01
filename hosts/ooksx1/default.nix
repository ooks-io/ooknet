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
        homeManager = false;
      };
      guest = {
        enable = true;
        name = "eureka";
        homeManager = true;
        shell = "fish";
      };
    };
    workstation = {
      environment = "gnome";
      theme = "minimal";
      profiles = ["media" "communication" "productivity"];
      default = {
        browser = "chrome";
        terminal = "ghostty";
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
