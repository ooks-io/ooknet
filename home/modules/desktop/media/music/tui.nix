{ pkgs, config, lib, ... }:

let
  inherit (config.colorscheme) palette;
  inherit (lib) mkIf;

  cfg = config.ooknet.desktop.media.music.tui;
  zellij = config.ooknet.multiplexer.zellij;
  multiplexer= config.ooknet.console.multiplexer;

  # removed image support because it was causing issues with zellij
  spotify-cli = pkgs.spotify-player.override {
    withImage = false;
    withSixel = false;
  };
in

{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      termusic
      spotify-cli
      alsa-utils
      mpv
    ];

    programs.cava = {
      enable = true;
      settings = {
        general.framerate = 60;
        color = {
          gradient = 1;
          gradient_count = 5;
          gradient_color_1 = "'#${palette.base0A}'";
          gradient_color_2 = "'#${palette.base0B}'";
          gradient_color_3 = "'#${palette.base0C}'";
          gradient_color_4 = "'#${palette.base0D}'";
          gradient_color_5 = "'#${palette.base0E}'";
        };
      };
    };

    xdg.configFile."spotify-player/app.toml".text =  /* toml */ ''
      theme = "default"
      client_id = "fc4c3656d7cc4a7ea70c6080965f8b1a"
      client_port = 8080
      tracks_playback_limit = 50
      playback_format = "{track} • {artists}\n{album}\n{metadata}"
      notify_format = { summary = "{track} • {artists}", body = "{album}" }
      app_refresh_duration_in_ms = 32
      playback_refresh_duration_in_ms = 0
      page_size_in_rows = 20
      enable_media_control = false
      enable_streaming = "Always"
      enable_notify = true
      enable_cover_image_cache = false
      notify_streaming_only = false
      default_device = "${config.home.sessionVariables.HN}"
      play_icon = "▶"
      pause_icon = "▌▌"
      liked_icon = "♥"
      playback_window_position = "Top"
      cover_img_length = 9
      cover_img_width = 5
      playback_window_width = 6

      [device]
      name = "${config.home.sessionVariables.HN}"
      device_type = "speaker"
      volume = 100
      bitrate = 320
      audio_cache = false
      normalization = false
    '';
    
    xdg.configFile."zellij/layouts/music.kdl".text = mkIf (zellij.enable || multiplexer == "zellij") /* kdl */ ''
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
                  border_format   "#[fg=#${palette.base0D}]{char}"
                  border_position "bottom"

                  hide_frame_for_single_pane "true"

                  mode_normal       "#[fg=${palette.base0D}]󰝚"
            
                  tab_normal   "#[bg=#${palette.base01}] {name} "
                  tab_active   "#[bg=#${palette.base02}] {name} "
                  tab_separator "  "

                  datetime        "#[fg=#${palette.base05},bold] {format} "
                  datetime_format "%I:%M %p"
                  datetime_timezone "${config.home.sessionVariables.TZ}"
              }
          }
          children
      }

          tab name="spotify" focus=true {
              pane name="spotify" {
                  borderless true
                  command "spotify_player"
                  focus true
              }
              pane name="Visualizer" {
                  borderless false
                  split_direction "horizontal"
                  size "20%"
                  command "cava"
              }
          }
      }
    '';
    home.shellAliases = mkIf (zellij.enable || multiplexer == "zellij") {
      zjm = "zellij --layout music";
    };
  };
  
}
