{ config, lib, ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
  pointer = config.home.pointerCursor;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        general = {

          gaps_in = 10;
          gaps_out = 10;
          border_size = 2;
          cursor_inactive_timeout = 4;
          "col.active_border" = "0xff${config.colorscheme.colors.base05}";
          "col.inactive_border" = "0xff${config.colorscheme.colors.base02}";
          };

        exec-once = [
          "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
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

          drop_shadow = true;
          shadow_range = 12;
          shadow_offset = "3 3";
          "col.shadow" = "0x44000000";
          "col.shadow_inactive" = "0x66000000";
        };
    
        animations = {
          enabled = false;
        };
      };
    };
  };
}
