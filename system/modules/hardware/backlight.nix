{ lib, config, ... }:

let
  cfg = config.systemModules.hardware.backlight;
in

{
  config = lib.mkIf cfg.enable {
    hardware.brillo.enable = true;
    services.clight = {
      enable = true;
      temperature = {
        night = 3000;
        day = 6000;
      };
      settings = {
        verbose = true;
        backlight.disabled = true;
        dpms.timeouts = [900 300];
        dimmer.timeouts = [870 270];
        screen.disabled = true;
        sunrise = "9:00";
        sunset = "20:00";
      };
    };
  };
}
