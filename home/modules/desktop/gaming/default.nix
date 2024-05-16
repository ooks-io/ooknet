{ lib, ... }:

{

  imports = [
    ./factorio
    ./lutris
    ./bottles
  ];

  options.homeModules.desktop.gaming = {
    factorio = {
      enable = lib.mkEnableOption "Enable factorio home module";
    };
  };
  
}
