{
  osConfig,
  hozen,
  ...
}: let
  inherit (osConfig.ooknet.appearance) cursor;
  inherit (hozen) color;
in {
  wayland.windowManager.hyprland = {
    #plugins = [inputs'.hyprland-plugins.packages.borders-plus-plus];
    settings = {
      # cursor = {
      #   inactive_timeout = 4;
      # };
      general = {
        border_size = 2;
        "col.inactive_border" = "rgb(${color.neutrals."700"})";
        "col.active_border" = "rgb(${color.neutrals."650"})";
        gaps_in = 10;
        gaps_out = 10;
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
          enabled = true;
          range = 2;
          sharp = true;
          offset = "2 2";
          color = "0xff${color.neutrals."850"}";
          color_inactive = "0xff${color.neutrals."850"}";
        };
      };
      # FIXME
      #"plugin:borders-plus-plus" = {
      #  enabled = true;
      #  add_borders = 1;
      #  "col.border_1" = "rgb(${color.neutrals."600"})";
      #
      #  border_size_1 = 2;
      #  border_size_2 = 2;
      #  natural_rounding = false;
      #};
      animations = {
        enabled = false;
      };
    };
  };
}
