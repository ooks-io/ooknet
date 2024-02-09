{ pkgs, config, lib, ... }:

let
  inherit (config.colorscheme) colors;
  cfg = config.homeModules.desktop.media.music.tui;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      termusic
      spotify-player
      ytui-music
      alsa-utils
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
  };
  
}
