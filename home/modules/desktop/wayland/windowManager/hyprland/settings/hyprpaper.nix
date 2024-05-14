{ lib, config, inputs,  ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
  wallpaperPath = config.homeModules.theme.wallpaper.path;
in

{
  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
    };
    xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = , ${wallpaperPath}
  '';
  };
}
