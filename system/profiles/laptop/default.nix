{ config, lib, ... }:
let
  cfg = config.systemProfile.laptop;
in 
{
  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    systemModules = {
      hardware = {
        bluetooth.enable = true;
        power.enable = true;
        backlight.enable = true;
      };
    };
  };
}
