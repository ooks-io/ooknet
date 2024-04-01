{ lib, ... }:

{
  imports = [
    ./gammastep
    ./tools
  ];

  options.homeModules.desktop.wayland.utility = {
    tools = {
      enable = lib.mkEnableOption "Enable wayland specific tools";
    };
    gammastep = {
      enable = lib.mkEnableOption "Enable gammastep module";
    };
  };
}
