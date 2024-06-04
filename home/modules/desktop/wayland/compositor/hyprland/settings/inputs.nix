{ lib, config, ... }:

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings.input = {
      kb_layout = "us";
      follow_mouse = 1;
      touchpad.natural_scroll = "no";
      mouse_refocus = false;
    };
  };
  
}
