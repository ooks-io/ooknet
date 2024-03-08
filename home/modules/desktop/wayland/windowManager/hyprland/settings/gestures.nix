{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };
  };
}
