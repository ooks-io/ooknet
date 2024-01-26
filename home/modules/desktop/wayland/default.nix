{ lib, ... }:
{
  imports = [
    ./bar
    ./lockscreen
    ./notification
    ./utility
    ./windowManager
    # ./launcher
  ];

  options.homeModules.desktop.wayland = {
    base = {
      enable = lib.mkEnableOption "Enable wayland specific utilities";
    };
  };
}
