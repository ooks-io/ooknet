{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    home.packages = [ pkgs.hyprshade ];
    # TODO: implement hyprshade configuration
  };
}
