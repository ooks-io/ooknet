{
  osConfig,
  pkgs,
  config,
  lib,
  hozen,
  self',
  ...
}: let
  inherit (lib) mkIf getExe elem;
  inherit (builtins) attrValues;
  inherit (osConfig.networking) hostName;
  inherit (osConfig.ooknet.workstation) profiles;
  inherit (osConfig.age.secrets) spotify_key;
  inherit (config.ooknet) binds;
  inherit (hozen) color;
in {
  config = mkIf (elem "media" profiles) {
    home.packages = attrValues {
      inherit
        (pkgs)
        alsa-utils
        mpv
        ;
    };

    ooknet.binds.spotify = {
      launch = "${binds.terminalLaunch} spotify_player";
      next = "spotify_player playback next";
      previous = "spotify_player playback previous";
      play = "spotify_player playback play-pause";
    };

    programs = {
      spotify-player = {
        enable = true;
        package = self'.packages.spotify-player;
        settings = {
          theme = "default";
          client_id_command = "cat ${spotify_key.path}";
          client_port = 8080;
          tracks_playback_limit = 50;
          playback_format = "{track} • {artists}\n{album}\n{metadata}";
          notify_format = {
            summary = "{track} • {artists}";
            body = "{album}";
          };
          app_refresh_duration_in_ms = 32;
          playback_refresh_duration_in_ms = 0;
          page_size_in_rows = 20;
          enable_media_control = false;
          enable_streaming = "Always";
          enable_notify = true;
          enable_cover_image_cache = false;
          notify_streaming_only = false;
          default_device = "${hostName}";
          play_icon = "▶";
          pause_icon = "▌▌";
          liked_icon = "♥";
          playback_window_position = "Top";
          playback_window_width = 6;

          device = {
            name = "${hostName}";
            device_type = "speaker";
            volume = 60;
            bitrate = 320;
            audio_cache = false;
            normalization = false;
          };
        };
      };

      cava = {
        enable = true;
        settings = {
          general.framerate = 60;
          color = {
            gradient = 1;
            gradient_count = 5;
            gradient_color_1 = "'#${color.primary.base}'";
            gradient_color_2 = "'#${color.primary.hard1}'";
            gradient_color_3 = "'#${color.primary.hard2}'";
            gradient_color_4 = "'#${color.primary.hard3}'";
            gradient_color_5 = "'#${color.primary.hard4}'";
          };
        };
      };
    };
  };
}
