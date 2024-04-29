{ lib, ... }:

{
  imports = [ 
  ./mediaServer
  ./system76Scheduler
  ./dbus
  ];

  options.systemModules.services = {
    mediaServer = {
      enable = lib.mkEnableOption "Enable mediaserver service module";
    };
  };
  
}
