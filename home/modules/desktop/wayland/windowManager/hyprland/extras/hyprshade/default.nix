{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.desktop.wayland.windowManager.hyprland.extras.hyprshade;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hyprshade ];
    # TODO: implement hyprshade configuration
  };
}
