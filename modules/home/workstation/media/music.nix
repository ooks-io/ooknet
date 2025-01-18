{
  osConfig,
  pkgs,
  config,
  lib,
  hozen,
  ...
}: let
  inherit (lib) mkIf getExe elem;
  inherit (builtins) attrValues;
  inherit (osConfig.networking) hostName;
  inherit (osConfig.ooknet.console.tools) zellij;
  inherit (osConfig.ooknet.console) multiplexer;
  inherit (osConfig.ooknet.workstation) profiles;
  inherit (osConfig.age.secrets) spotify_key;
  inherit (config.ooknet) binds;
  inherit (hozen) color;
in {
  config = mkIf (elem "media" profiles) {
    home.packages = attrValues {
      inherit
        (pkgs)
        termusic
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
        enable = false; # FIX ME!!!
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

    xdg.configFile."zellij/layouts/music.kdl".text =
      mkIf (zellij.enable || multiplexer == "zellij")
      /*
      kdl
      */
      ''
        layout {
        default_tab_template {
            pane size=2 borderless=true {
                plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                    format_left   "{mode}"
                    format_right  "{session} {datetime}"
                    format_center "#[fg=#89B4FA,bold] {tabs}"
                    format_space  ""

                    border_enabled  "true"
                    border_char     "─"
                    border_format   "#[fg=#${color.base0D}]{char}"
                    border_position "bottom"

                    hide_frame_for_single_pane "true"

                    mode_normal       "#[fg=${color.base0D}]󰝚"

                    tab_normal   "#[bg=#${color.base01}] {name} "
                    tab_active   "#[bg=#${color.base02}] {name} "
                    tab_separator "  "

                    datetime        "#[fg=#${color.base05},bold] {format} "
                    datetime_format "%I:%M %p"
                    datetime_timezone "${osConfig.time.timeZone}"
                }
            }
            children
        }

            tab name="spotify" focus=true {
                pane name="spotify" {
                    borderless true
                    command "${getExe pkgs.spotify-player}"
                    focus true
                }
                //pane name="Visualizer" {
                //    borderless false
                //    split_direction "horizontal"
                //    size "20%"
                //    command "cava"
                //}
            }
        }
      '';

    home.shellAliases = mkIf (zellij.enable || multiplexer == "zellij") {
      zjm = "zellij --layout music";
    };
  };
}
