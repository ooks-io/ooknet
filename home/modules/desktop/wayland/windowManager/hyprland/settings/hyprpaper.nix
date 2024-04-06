{ lib, config, inputs,  ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
  wallpaperPath = config.homeModules.theme.wallpaper.path;
in

{
  imports = [ inputs.hyprpaper.homeManagerModules.hyprpaper ];
  
  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      preloads = ["${wallpaperPath}"];
      wallpapers = [", ${wallpaperPath}"];
      ipc = false;
    };
  };
}
