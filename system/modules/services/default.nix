{ lib, ... }:

{
  imports = [ 
  ./mediaServer
  ./system76Scheduler
  ./dbus
  ./kdeconnect
  ./gnome
  ./gvfs
  ];

  options.systemModules.services = {
    mediaServer = {
      enable = lib.mkEnableOption "Enable mediaserver service module";
    };
  };
  
}
