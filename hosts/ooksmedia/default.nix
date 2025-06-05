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
      # Enable deployment settings
      deployment = {
        enable = true;
        remoteBuild = true;
        fastConnection = true;
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
