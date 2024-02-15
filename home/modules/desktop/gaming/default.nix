{ lib, ... }:

{

  imports = [
    ./slippi
  ];

  options.homeModules.desktop.gaming = {
    slippi = {
      enable = lib.mkEnableOption "Enable Slippi home module";
    };
  };
  
}
