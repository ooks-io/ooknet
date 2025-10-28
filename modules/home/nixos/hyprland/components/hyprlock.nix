{
  lib,
  osConfig,
  ook,
  ...
}: let
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (osConfig.ooknet.hardware) primaryMonitor;
  inherit (ook) color;
  inherit (lib) mkIf;
in {
  config = mkIf (environment == "hyprland") {
    ooknet.binds.lock = "loginctl lock-session";

    programs.hyprlock = {
      enable = true;

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
          monitor = primaryMonitor;
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
          monitor = primaryMonitor;
          text = "password";
          position = "-165, 0";
          valign = "center";
          halign = "center";
          color = "0xff${color.primary.base}";
          font_size = 16;
          font_family = "${fonts.monospace.family}";
        };
      };
    };
  };
}
