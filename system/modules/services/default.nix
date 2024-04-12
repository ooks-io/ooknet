{ lib, ... }:

{
  imports = [ 
  ./mediaServer
  ./system76Scheduler
  ./nixarr
  ];

  options.systemModules.services = {
    mediaServer = {
      enable = lib.mkEnableOption "Enable mediaserver service module";
    };

  };
  
}
