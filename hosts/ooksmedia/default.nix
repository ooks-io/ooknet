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
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
    server = {
      ookflix = {
        gpuAcceleration.enable = true;
        services = {
          plex.enable = true;
          jellyfin.enable = true;
        };
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  system.stateVersion = lib.mkDefault "24.11";
}
