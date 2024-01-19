
{ lib, config, ... }:

let
  cfg = config.systemModules.hardware.power;
in

{
  config = lib.mkIf cfg.enable {
    services.system76-scheduler.settings.cfsProfiles.enable = true;

    services.tlp = {
      enable = true;
      settings = {
        cpu_boost_on_ac = 1;
        cpu_boost_on_bat = 0;
        cpu_scaling_governor_on_ac = "performance";
        cpu_scaling_governor_on_bat = "powersave";
      };
    };

    services = {
      upower.enable = true;
      thermald.enable = true;
      power-profiles-daemon.enable = false;
      logind = {
        lidSwitch = "suspend";
      };
    };
    powerManagement.powertop.enable = true;
  };
}
