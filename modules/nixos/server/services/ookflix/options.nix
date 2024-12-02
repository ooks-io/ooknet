{
  lib,
  config,
  self,
  ...
}: let
  ookflixLib = import ./lib.nix {inherit lib config self;};

  inherit (ookflixLib) mkVolumeOption mkGroupOption mkServiceOptions mkBasicServiceOptions mkPortOption;
  inherit (lib) mkOption mkEnableOption elem;
  inherit (config.ooknet.server) services;
  inherit (lib.types) enum;
in {
  options.ooknet.server.ookflix = {
    enable =
      mkEnableOption "Enable ookflix a container based media server module"
      // {default = elem "ookflix" services;};
    gpuAcceleration = {
      enable =
        mkEnableOption "Enable GPU acceleration for video streamers"
        // {default = elem "ookflix" services;};
      type = mkOption {
        type = enum ["nvidia" "intel" "amd"];
        default = config.ooknet.hardware.gpu.type;
        description = ''
          What GPU type to use for GPU acceleration.
          Defaults to system GPU type (ooknet.hardware.gpu.type)
        '';
      };
    };
    volumes = {
      state.root = mkVolumeOption "root" "/var/lib/ookflix";
      data.root = mkVolumeOption "root" "/jellyfin";

      torrents = {
        root = mkVolumeOption "data" "torrents";
        tv = mkVolumeOption "torrents" "tv";
        movies = mkVolumeOption "torrents" "movies";
        books = mkVolumeOption "torrents" "books";
      };

      usenet = {
        root = mkVolumeOption "data" "usenet";
        incomplete = mkVolumeOption "usenet" "incomplete";
        complete = {
          root = mkVolumeOption "usenet" "complete";
          tv = mkVolumeOption "usenet/complete" "tv";
          movies = mkVolumeOption "usenet/complete" "movies";
          books = mkVolumeOption "usenet/complete" "books";
        };
      };
      media = {
        root = mkVolumeOption "data" "media";
        movies = mkVolumeOption "media" "movies";
        tv = mkVolumeOption "media" "tv";
        books = mkVolumeOption "media" "books";
      };
    };
    # Shared groups
    groups = {
      media = mkGroupOption "media" 992;
      downloads = mkGroupOption "downloader" 981;
    };

    services = {
      jellyfin = mkServiceOptions "jellyfin" {
        port = 8096;
        uid = 994;
        gid = 994;
      };
      plex = mkServiceOptions "plex" {
        port = 32400;
        uid = 195;
        gid = 195;
      };
      sonarr = mkServiceOptions "sonarr" {
        port = 8989;
        uid = 274;
        gid = 274;
      };
      radarr = mkServiceOptions "radarr" {
        port = 7878;
        uid = 275;
        gid = 275;
      };
      prowlarr = mkServiceOptions "prowlarr" {
        port = 9696;
        uid = 982;
        gid = 987;
      };
      qbittorrent =
        mkServiceOptions "qbittorrent" {
          port = 8080;
          uid = 377;
          gid = 377;
        }
        // {torrentPort = mkPortOption 58080 "Torrenting Port for qbittorrent" 58080;};
      jellyseer = mkServiceOptions "jellyseer" {
        port = 5055;
        uid = 345;
        gid = 345;
      };
      tautulli = mkServiceOptions "tautulli" {
        port = 8181;
        uid = 355;
        gid = 355;
      };
      gluetun = mkBasicServiceOptions "gluetun" {
        uid = 356;
        gid = 357;
      };
    };
  };
}
