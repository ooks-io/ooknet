{ lib, config, ... }:

let
  cfg = config.systemModules.hardware.backlight;
in

{
  config = lib.mkIf cfg.enable {
    hardware.brillo.enable = true;
    services.clight = {
      enable = true;
      settings = {
        verbose = true;
        backlight.disabled = true;
        dpms.timeouts = [900 300];
        dimmer.timeouts = [870 270];
        gamma.long_transition = true;
        screen.disabled = true;
      };
    };
  };
}
