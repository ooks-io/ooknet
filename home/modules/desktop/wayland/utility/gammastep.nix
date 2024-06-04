{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.wayland;
in

{
  config = mkIf cfg.enable {
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
