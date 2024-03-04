{ lib, ... }:

{
  imports = [
    ./anyrun
    ./rofi
  ];

  options.homeModules.desktop.wayland.launcher = {
    anyrun = {
      enable = lib.mkEnableOption "enable anyrun launcher module";
    };
    rofi = {
      enable = lib.mkEnableOption "enable rofi launcher module";
    };
  };
}
