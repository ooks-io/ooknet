{ lib, ... }:
{
  imports = [
    #./eww
    ./ags
    #./waybar -- needs to be implemented
  ];

  options.homeModules.desktop.wayland.bar = {
    eww = {
      enable = lib.mkEnableOption "Enable Eww bar";
    };
    ags = {
      enable = lib.mkEnableOption "Enable ags bar";
    };
  };

}
