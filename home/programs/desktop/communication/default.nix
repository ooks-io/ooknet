{ lib, ... }:

{
  imports = [
    ./discord
  ];

  options.programs.desktop.communication = {
    discord = {
      enable = lib.mkEnableOption "Enable discord module";
    };
  };
}
