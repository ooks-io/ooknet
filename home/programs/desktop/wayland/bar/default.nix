{ lib, config, ... }:
{
  imports = [
    #./eww
    #./ags -- needs to be implemented
    #./waybar -- needs to be implemented
  ];

  options.programs.desktop.wayland.bar = {
    eww = {
      enable = lib.mkEnableOption "Enable Eww bar";
    };
  };

}