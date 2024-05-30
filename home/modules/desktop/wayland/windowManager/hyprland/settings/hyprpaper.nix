{ lib, config, inputs,  ... }:

let
  cfg = config.ooknet.desktop.wayland.windowManager.hyprland;
  wallpaperPath = config.ooknet.theme.wallpaper.path;
in

{
  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
    };
    xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = , ${wallpaperPath}
    splash = false
    ipc = off
  '';
  };
}
