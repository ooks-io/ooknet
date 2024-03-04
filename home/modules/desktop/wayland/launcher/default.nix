{ lib, ... }:

{
  imports = [
    ./anyrun
  ];

  options.homeModules.desktop.wayland.launcher = {
    anyrun = {
      enable = lib.mkEnableOption "enable anyrun launcher module";
    };
  };
}
