{ lib, config, ... }:

let
  cfg = config.ooknet.desktop.wayland.windowManager.hyprland;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.env = [
      "XDG_SESSION_DESKTOP,hyprland"
      "XDG_CURRENT_DESKTOP,hyprland"
    ]; 
  };

  
}
