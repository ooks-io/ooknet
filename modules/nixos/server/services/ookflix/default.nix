{
  lib,
  config,
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (config.ooknet.server) services;
in {
  imports = [
    ./jellyfin.nix
    ./plex.nix
    ./jellyseer.nix
    ./tautulli.nix
    ./sonarr.nix
    ./prowlarr.nix
    ./gluetun.nix
    ./transmission.nix
    ./shared.nix

    ./options.nix
  ];

  config = mkIf (elem "ookflix" services) {
    ooknet.server.ookflix = {
      gpuAcceleration.enable = true;
      services = {
        jellyfin.enable = true;
        plex.enable = true;
        jellyseer.enable = true;
        tautulli.enable = true;
      };
    };
  };
}
