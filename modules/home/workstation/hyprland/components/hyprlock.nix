{
  lib,
  osConfig,
  inputs',
  hozen,
  ...
}: let
  inherit (osConfig.ooknet.appearance) colorscheme fonts;
  inherit (colorscheme) palette;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (hozen) color;
  inherit (lib) mkIf;
in {
  config = mkIf (environment == "hyprland") {
    ooknet.binds.lock = "loginctl lock-session";

    programs.hyprlock = {
      enable = true;
      package = inputs'.hyprlock.packages.default;

      settings = {
        enable = true;

        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          no_fade_out = true;
        };

        background = {
          monitor = "";
          path = "";
          color = "0xff${color.layout.body}";
        };

        input-field = {
          size = "200, 30";

          position = "0, 0";
          outline_thickness = 2;
          dots_spacing = 0.3;
          dots_rounding = 0;
          rounding = 0;
          fade_on_empty = false;
          placeholder_text = "";
          outer_color = "0xff${color.secondary.base}";
          inner_color = "0xff${color.layout.menu}";
          font_color = "0xff${color.typography.text}";
        };

        label = {
          monitor = "";
          text = " \ ";
          position = "0, 150";
          valign = "center";
          halign = "center";
          color = "0xff${color.red.base}";
          font_size = 30;
          font_family = "${fonts.monospace.family}";
        };
      };
    };
  };
}
