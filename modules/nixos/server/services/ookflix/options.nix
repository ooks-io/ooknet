{
  lib,
  config,
  ...
}: let
  ookflixLib = import ./lib.nix {inherit lib config;};

  inherit (ookflixLib) mkVolumeOption mkGroupOption mkServiceOptions;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) enum;
  inherit (config.ooknet) server;
  cfg = server.ookflix;
in {
  options.ooknet.server.ookflix = {
    enable = mkEnableOption "Enable ookflix a container based media server module";
    gpuAcceleration = {
      enable = mkEnableOption "Enable GPU acceleration for video streamers";
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
      content.root = mkVolumeOption "root" "/jellyfin";
      downloads = {
        root = mkVolumeOption "${cfg.content.root}/downloads";
        incomplete = mkVolumeOption "downloads" "incomplete";
        complete = mkVolumeOption "downloads" "complete";
        watch = mkVolumeOption "downloads" "watch";
      };

      media = {
        root = mkVolumeOption "root" "${cfg.volumes.content.root}/media";
        movies = mkVolumeOption "media" "movies";
        tv = mkVolumeOption "media" "tv";
      };
    };
    # Shared groups
    groups = {
      media = mkGroupOption "media" 992;
      downloader = mkGroupOption "downloader" 981;
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
      transmission = mkServiceOptions "transmission" {
        port = 9091;
        uid = 70;
        gid = 70;
      };
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
    };
  };
}
