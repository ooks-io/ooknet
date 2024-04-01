{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.wayland.utility.gammastep;
in

{
  config = lib.mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      enableVerboseLogging = true;
      provider = "geoclue2";
      temperature = {
        day = 6000;
        night = 4000;
      };
      settings.general.adjustment-method = "wayland";
    };
  };
}
