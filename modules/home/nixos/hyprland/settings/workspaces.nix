{osConfig, ...}: let
  inherit (osConfig.ooknet) hardware;
  multiMonitor = builtins.length hardware.monitors > 1;
  primary = hardware.primaryMonitor;
  secondary =
    if multiMonitor
    then (builtins.elemAt hardware.monitors 1).name
    else primary;
in {
  wayland.windowManager.hyprland.workspaces = {
    "1" = {
      name = "terminal";
      monitor = primary;
      default = true;
    };
    "2" = {
      name = "browser";
      monitor = primary;
    };
    "3" = {
      name = "media";
      monitor = secondary;
      default = true;
    };
    "4" = {
      name = "discord";
      monitor = secondary;
    };
    "5" = {
      name = "gaming";
      monitor = primary;
    };
    "r[6-9]" = {
      monitor = primary;
    };
  };
}
