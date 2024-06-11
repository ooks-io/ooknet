{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.services.system76Scheduler;
in

{
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
