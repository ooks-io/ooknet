{ lib, ... }:
{
  imports = [
    #./eww
    # ./ags
    ./waybar
  ];

  options.homeModules.desktop.wayland.bar = {
    eww = {
      enable = lib.mkEnableOption "Enable Eww bar";
    };
    ags = {
      enable = lib.mkEnableOption "Enable ags bar";
    };
    waybar = {
      enable = lib.mkEnableOption "Enable waybar bar";
    };
  };

}
