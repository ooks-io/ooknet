{ lib, ... }:
{

  imports = [
    #./gtkLock --- still needs to be implemented
    ./swaylock
    ./hyprlock
  ];

  options.homeModules.desktop.wayland.lockscreen = {
    swaylock = {
      enable = lib.mkEnableOption "Enable Swaylock screen";
    };
    hyprlock = {
      enable = lib.mkEnableOption "Enable hyprlock screen";
    };
  };

  #TODO: make assertion to prevent 2 lockscreens
}

