{
  pkgs,
  osConfig,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe getExe' mkIf optionals;
  inherit (osConfig.ooknet.workstation) environment sunshine;

  dpms = "${getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms";
  lock = "${getExe' pkgs.systemd "loginctl"} lock-session";
  hyprlock = getExe config.programs.hyprlock.package;
in {
  config = mkIf (environment == "hyprland") {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = hyprlock;
          before_sleep_cmd = lock;
        };
        listener =
          [
            {
              timeout = 300;
              on-timeout = hyprlock;
            }
          ]
          # keep the display powered on while sunshine streaming is enabled
          # wayland kms capture 503s on a dpms-off display and cant be woken remotely
          ++ optionals (!sunshine.enable) [
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
