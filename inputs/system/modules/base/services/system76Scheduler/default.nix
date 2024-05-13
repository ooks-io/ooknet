{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  config = mkIf (host.type != "phone") {

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
