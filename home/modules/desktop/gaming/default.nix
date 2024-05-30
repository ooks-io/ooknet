{ lib, ... }:

{

  imports = [
    ./factorio
    ./lutris
    ./bottles
  ];

  options.ooknet.desktop.gaming = {
    factorio = {
      enable = lib.mkEnableOption "Enable factorio home module";
    };
  };
  
}
