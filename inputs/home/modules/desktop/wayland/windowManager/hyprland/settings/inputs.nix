{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.input = {
      kb_layout = "us";
      follow_mouse = 1;
      touchpad.natural_scroll = "no";
    };
  };
  
}
