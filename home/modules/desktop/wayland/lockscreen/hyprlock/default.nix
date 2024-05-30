{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.ooknet.desktop.wayland.lockscreen.hyprlock;
  fonts = config.ooknet.theme.fonts;
  inherit (config.colorscheme) palette;
in

{
  imports = [ 
    # inputs.hyprlock.homeManagerModules.default
    # inputs.hypridle.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    home.sessionVariables.LOCKER = "hyprlock";
    programs.hyprlock = {
      settings = {
        enable = true;
        general = {
          hide_cursor = true;
          no_fade_in = true;
        };
        backgrounds = [
          {
            monitor = "";
            path = "";
            color = "0xff${palette.base01}";
          }
        ];
        input-fields = [
          {
            size = {
              width = 300;
              height = 40;
            };      
            position = {
              x = 0;
              y = 0;
            };
            outline_thickness = 2;
            dots_spacing = 0.2;
            fade_on_empty = false;
            placeholder_text = "";
            outer_color = "0xff${palette.base02}";
            inner_color = "0xff${palette.base00}";
            font_color = "0xff${palette.base05}";
          }
        ];
        labels = [
          {
            monitor = "";
            text = "  ";
            position = {
              x = 0;
              y = 80; 
            };
            color = "0xff${palette.base08}";
            font_size = 30;
            font_family = "${fonts.monospace.family}";
          }
          {
            monitor = "";
            text = "$TIME";
            position = {
              x = 0;
              y = -80; 
            };
            color = "0xff${palette.base0B}";
            font_size = 20;
            font_family = "${fonts.monospace.family}";
          }
        ];
      };
    };
  };
}
