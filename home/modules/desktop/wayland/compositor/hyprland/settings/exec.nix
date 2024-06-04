{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      exec = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
      exec-once = [
        "${pkgs._1password-gui}/bin/1password --silent"
        # "${pkgs.live-buds-cli}/bin/earbuds -d"
        # "waybar"
      ];
    };
  };
}
