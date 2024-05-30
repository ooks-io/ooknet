{ lib, ... }:

{
  imports = [
    # ./anyrun
    ./rofi
    ./tofi
  ];

  options.ooknet.desktop.wayland.launcher = {
    anyrun = {
      enable = lib.mkEnableOption "enable anyrun launcher module";
    };
    rofi = {
      enable = lib.mkEnableOption "enable rofi launcher module";
    };
    tofi = {
      enable = lib.mkEnableOption "enable tofi launcher module";
    };
  };
}
