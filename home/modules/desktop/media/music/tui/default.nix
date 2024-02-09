{ pkgs, config, lib, ... }:

let
  inherit (config.colorscheme) colors;
  cfg = config.homeModules.desktop.media.music.tui;
  zellij = config.homeModules.console.multiplexer.zellij;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      termusic
      spotify-player
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
          gradient_color_1 = "'#${colors.base0A}'";
          gradient_color_2 = "'#${colors.base0B}'";
          gradient_color_3 = "'#${colors.base0C}'";
          gradient_color_4 = "'#${colors.base0D}'";
          gradient_color_5 = "'#${colors.base0E}'";
        };
      };
    };
    xdg.configFile."zellij/layouts/music.kdl".text = lib.mkIf zellij.enable /* kdl */ ''
      layout {
      default_tab_template {
          pane size=2 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                  format_left  "{mode} #[fg=#89B4FA,bold] {tabs}"
                  format_right "{session} {datetime}"
                  format_space ""

                  border_enabled  "true"
                  border_char     "─"
                  border_format   "#[fg=#${colors.base0D}]{char}"
                  border_position "bottom"

                  hide_frame_for_single_pane "true"

                  mode_normal       "#[fg=${colors.base0D}]󰝚"
            
                  tab_normal   "#[bg=#${colors.base01}] {name} "
                  tab_active   "#[bg=#${colors.base02}] {name} "
                  tab_separator "  "

                  datetime        "#[fg=#${colors.base05},bold] {format} "
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
    home.shellAliases = lib.mkIf zellij.enable {
      zjm = "zellij --layout music";
    };
  };
  
}
