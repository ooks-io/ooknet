{
  osConfig,
  hozen,
  ...
}: let
  inherit (osConfig.ooknet.appearance) cursor;
  inherit (hozen) color;
in {
  wayland.windowManager.hyprland = {
    settings = {
      # cursor = {
      #   inactive_timeout = 4;
      # };
      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "0xff${color.border.active}";
        "col.inactive_border" = "0xff${color.border.inactive}";
      };

      exec-once = [
        "hyprctl setcursor ${cursor.name} ${toString cursor.size}"
      ];

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
          range = 12;
          offset = "3 3";
          color = "0x44000000";
          color_inactive = "0x66000000";
        };
      };
      animations = {
        enabled = false;
      };
    };
  };
}
