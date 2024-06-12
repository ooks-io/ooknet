{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.ooknet.host;
in

{
  config = mkIf (host.type == "laptop" && host.role == "workstation") {
    ooknet = {
      services = {
        gnomeServices.enable = true;
        gvfs.enable = true;
        dbus.enable = true;
        system76Scheduler.enable = true; 
      };
      programs = {
        _1password.enable = true;
        dconf.enable = true;
        kdeconnect.enable = true;
      };
    };
  };
}
