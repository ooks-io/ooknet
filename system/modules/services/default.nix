{ lib, ... }:

{
  imports = [ 
  ./mediaServer
  ];

  options.systemModules.services = {
    mediaServer = {
      enable = lib.mkEnableOption "Enable mediaserver service module";
    };
  };
  
}
