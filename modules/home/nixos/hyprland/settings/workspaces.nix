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
      default_name = "terminal";
      monitor = primary;
      default = true;
    };
    "2" = {
      default_name = "browser";
      monitor = primary;
    };
    "3" = {
      default_name = "media";
      monitor = secondary;
      default = true;
    };
    "4" = {
      default_name = "discord";
      monitor = secondary;
    };
    "5" = {
      default_name = "gaming";
      monitor = primary;
    };
    "r[6-9]" = {
      monitor = primary;
    };
  };
}
