{ config, lib, ... }:
let
  cfg = config.system.profile.laptop;
in 
{
  imports = [
    ../modules
  ];
  config = cfg.enable {
    system = {
      hardware = {
        bluetooth.enable = true;
        powerSettings.enable = true
        backlight.enable = true;
      };
    };
  };
}
