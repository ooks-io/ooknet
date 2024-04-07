{ lib, ... }:

{
  imports = [ 
  ./mediaServer
  ./system76Scheduler
  ];

  options.systemModules.services = {
    mediaServer = {
      enable = lib.mkEnableOption "Enable mediaserver service module";
    };
  };
  
}
