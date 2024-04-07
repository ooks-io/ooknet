{ lib, config, ... }:

let
  cfg = config.systemModules.hardware.ssd;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.systemModules.hardware.ssd = {
    enable = mkEnableOption "Enable bluetooth module";
  };
  
  config = mkIf cfg.enable {
    services.fstrim = {
      enable = true;
    };
    # only run fstrim while connected on AC
    systemd.services.fstrim = {
      unitConfig.ConditionACPower = true;
      serviceConfig = {
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    }; 
  };
}
