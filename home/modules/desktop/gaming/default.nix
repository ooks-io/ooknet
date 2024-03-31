{ lib, ... }:

{

  imports = [
    ./factorio
  ];

  options.homeModules.desktop.gaming = {
    factorio = {
      enable = lib.mkEnableOption "Enable factorio home module";
    };
  };
  
}
