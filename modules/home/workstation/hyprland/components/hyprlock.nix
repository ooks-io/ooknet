{
  lib,
  osConfig,
  inputs',
  ...
}: let
  inherit (osConfig.ooknet.appearance) colorscheme fonts;
  inherit (colorscheme) palette;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (lib) mkIf;
in {
  config = mkIf (environment == "hyprland") {
    ooknet.binds.lock = "hyprlock";

    programs.hyprlock = {
      enable = true;
      package = inputs'.hyprlock.packages.hyprlock;

      settings = {
        enable = true;
        general = {
          disable_loading_bar = true;
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
