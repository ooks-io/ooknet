{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  imports = [
    ./plex.nix
    ./users.nix
    ./options.nix
    ./jellyfin.nix
    ./transmission.nix
    ./file-permissions.nix
    ./vpn.nix
    inputs.vpn-confinement.nixosModules.default
  ];

  # short cut for enabling all media-server modules
  config = mkIf (elem "media-server" services) {
    ooknet.server.media-server = {
      enable = true;
      jellyfin.enable = true;
      plex.enable = true;
      transmission.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      prowlarr.enable = true;
    };
  };
}
