{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) wayland;
in {
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings.gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };
  };
}
