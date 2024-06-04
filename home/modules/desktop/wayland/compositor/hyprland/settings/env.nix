{ lib, config, ... }:

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings.env = [
      "XDG_SESSION_DESKTOP,hyprland"
      "XDG_CURRENT_DESKTOP,hyprland"
    ]; 
  };

  
}
