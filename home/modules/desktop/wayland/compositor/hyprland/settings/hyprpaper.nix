{ lib, config, inputs,  ... }:

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
  wallpaperPath = config.ooknet.wallpaper.path;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
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
