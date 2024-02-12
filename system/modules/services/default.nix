{ lib, ... }:

{
  imports = [ 
  ./jellyfin
  ./deluge
  ];

  options.systemModules.services = {
    jellyfin = {
      enable = lib.mkEnableOption "Enable jellyfin service module";
    };
    deluge = {
      enable = lib.mkEnableOption "Enable deluge service module";
    };
  };
  
}
