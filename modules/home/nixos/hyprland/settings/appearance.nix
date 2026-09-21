{
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (osConfig.ooknet.appearance) cursor;
  color = config.ooknet.appearance.colors;
in {
  wayland.windowManager.hyprland.settings = {
    on = [
      {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("hyprctl setcursor ${cursor.name} ${toString cursor.size}")
            end'')
        ];
      }
    ];

    config = {
      general = {
        border_size = 2;
        col = {
          inactive_border = "rgb(${color.neutrals."700"})";
          active_border = "rgb(${color.neutrals."650"})";
        };
        gaps_in = 10;
        gaps_out = 10;
      };

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;

        rounding = 0;

        blur = {
          enabled = false;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
          range = 2;
          sharp = true;
          offset = [2 2];
          color = "0xff${color.neutrals."850"}";
          color_inactive = "0xff${color.neutrals."850"}";
        };
      };

      # first frame after the splash, before hyprlock is up
      misc.background_color = "rgb(${color.layout.body})";

      animations.enabled = false;
    };
  };
}
