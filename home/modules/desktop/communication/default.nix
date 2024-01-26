{ lib, ... }:

{
  imports = [
    ./discord
  ];

  options.homeModules.desktop.communication = {
    discord = {
      enable = lib.mkEnableOption "Enable discord module";
    };
  };
}
