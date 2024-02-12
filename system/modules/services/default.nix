{ lib, ... }:

{
  imports = [ 
  ./jellyfin
  ];

  options.systemModules.services = {
    jellyfin = {
      enable = lib.mkEnableOption "Enable jellyfin service module";
    };
  };
  
}
