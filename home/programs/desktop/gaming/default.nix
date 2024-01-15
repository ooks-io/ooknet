{ lib, ... }:

{
  imports = [
    ./steam
  ];

  options.programs.desktop.games = {
    steam = {
      enable = lib.mkEnableOption "Enable steam";
      };
    };
  };
}
