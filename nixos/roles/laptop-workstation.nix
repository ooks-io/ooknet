{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) host;
in {
  config = mkIf (host.type == "laptop" && host.role == "workstation") {
    ooknet = {
      appearance.theme = "minimal";
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
