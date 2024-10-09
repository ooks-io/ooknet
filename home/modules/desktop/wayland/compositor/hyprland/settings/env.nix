{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) wayland;
in {
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings.env = [
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_CURRENT_DESKTOP,Hyprland"
    ];
  };
}
