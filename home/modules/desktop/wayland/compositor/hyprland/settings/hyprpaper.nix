{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) wayland;
  wallpaperPath = osConfig.ooknet.appearance.wallpaper.path;
in {
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
