{ lib, config, ... }:

let
  cfg = config.systemModules.services.system76Scheduler;
  inherit (lib) mkEnableOption mkIf;
in

{
  options.systemModules.services.system76Scheduler = {
    enable = mkEnableOption "Enable system 76 scheduler module";
  };

  config = mkIf cfg.enable {

    services.system76-scheduler = {
      enable = true;
    };
    # fix suspend issues
    powerManagement = {
      powerDownCommands = "systemctl stop system76-scheduler";
      resumeCommands = "systemctl start system76-scheduler";
    };
  };
}
