{ lib, ... }:
{

  imports = [
    ./mako
    #./dunst -- still needs to be implemented
  ];

  options.ooknet.desktop.wayland.notification = {
    mako = {
      enable = lib.mkEnableOption "Enable mako notification daemon";
    };
  };
}
