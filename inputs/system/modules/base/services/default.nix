{ lib, ... }:

{
  imports = [ 
  ./mediaServer
  ./system76Scheduler
  ./dbus
  ./gnome
  ./gvfs
  ];

  options.systemModules.services = {
    mediaServer = {
      enable = lib.mkEnableOption "Enable mediaserver service module";
    };
  };
  
}
