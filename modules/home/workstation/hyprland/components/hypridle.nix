{
  inputs',
  osConfig,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe mkIf;
  inherit (osConfig.ooknet.workstation) environment;

  hyprlock = getExe config.programs.hyprlock.package;
in {
  config = mkIf (environment == "hyprland") {
    services.hypridle = {
      enable = true;
      package = inputs'.hypridle.packages.hypridle;
      settings = {
        general = {
          lock_cmd = hyprlock;
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timout = 300;
            on-timeout = hyprlock;
          }
        ];
      };
    };
  };
}
