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
        backlight.enable = true;
      };
      laptop.power.enable = true;
    };
  };
}
