{ lib, ... }:
{
  imports = [
    #./spotify --- still needs to be implemented
    ./easyeffects
    ./tui
  ];

  options.ooknet.desktop.media.music = {
    tui = {
      enable = lib.mkEnableOption "Enable tui music";
    };
    spotify = {
      enable = lib.mkEnableOption "Enable spotify";
    };
  };
}
