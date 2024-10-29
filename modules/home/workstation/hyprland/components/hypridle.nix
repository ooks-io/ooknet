{
  inputs',
  pkgs,
  osConfig,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe getExe' mkIf;
  inherit (osConfig.ooknet.workstation) environment;

  dpms = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms";
  lock = "${getExe' pkgs.systemd "loginctl"} lock-session";
  hyprlock = getExe config.programs.hyprlock.package;
in {
  config = mkIf (environment == "hyprland") {
    services.hypridle = {
      enable = true;
      package = inputs'.hypridle.packages.hypridle;
      settings = {
        general = {
          lock_cmd = hyprlock;
          before_sleep_cmd = lock;
        };
        listener = [
          {
            timeout = 300;
            on-timeout = hyprlock;
          }
          {
            timeout = 360;
            on-timeout = "${dpms} off";
            on-resume = "${dpms} on";
          }
        ];
      };
    };
  };
}
