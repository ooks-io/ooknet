{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.workstation) environment;
  wallpaperPath = osConfig.ooknet.appearance.wallpaper.path;
in {
  config = mkIf (environment == "hyprland") {
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
