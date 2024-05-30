{ lib, ... }:

{
  imports = [
    ./gammastep
    ./tools
  ];

  options.ooknet.desktop.wayland.utility = {
    tools = {
      enable = lib.mkEnableOption "Enable wayland specific tools";
    };
    gammastep = {
      enable = lib.mkEnableOption "Enable gammastep module";
    };
  };
}
