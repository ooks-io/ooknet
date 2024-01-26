{ lib, ... }:
{

  imports = [
    #./gtkLock --- still needs to be implemented
    ./swaylock
  ];

  options.homeModules.desktop.wayland.lockscreen = {
    swaylock = {
      enable = lib.mkEnableOption "Enable Swaylock screen";
    };
  };
}

