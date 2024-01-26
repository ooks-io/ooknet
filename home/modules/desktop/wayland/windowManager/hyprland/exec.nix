{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in
{
  config = {
    wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
      exec = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.swaybg}/bin/swaybg -i ${config.wallpaper} --mode fill"
      ];
      exec-once = [
        "${pkgs._1password-gui}/bin/1password --silent"
        "${pkgs.live-buds-cli}/bin/earbuds -d"
        "eww daemon && eww open bar"
        "systemctl --user start clight"
      ];
    };
  };
}
