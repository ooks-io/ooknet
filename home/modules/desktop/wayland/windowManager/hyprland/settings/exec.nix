{ config, lib, pkgs, ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
      exec-once = [
        "${pkgs._1password-gui}/bin/1password --silent"
        "${pkgs.live-buds-cli}/bin/earbuds -d"
        "waybar"
      ];
    };
  };
}
