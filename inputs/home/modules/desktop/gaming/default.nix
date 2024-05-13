{ lib, ... }:

{

  imports = [
    ./factorio
    ./lutris
  ];

  options.homeModules.desktop.gaming = {
    factorio = {
      enable = lib.mkEnableOption "Enable factorio home module";
    };
  };
  
}
