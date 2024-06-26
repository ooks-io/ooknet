{ config, lib, ... }:

let
  inherit (config.colorscheme) palette;
  inherit (lib) mkIf;
  fonts = config.ooknet.fonts;
  wallpaperPath = config.ooknet.wallpaper.path;
  wayland = config.ooknet.wayland;
in
{
  config = mkIf (wayland.locker == "swaylock") {
    ooknet.binds.lock = "swaylock";
    programs.swaylock = {
      enable = true;
      settings = {
        image = "${wallpaperPath}";
        font = fonts.monospace.family;
        color = "#${palette.base01}";
        ring-color = "#${palette.base02}";
        inside-wrong-color = "#${palette.base08}";
        ring-wrong-color = "#${palette.base08}";
        key-hl-color = "#${palette.base0B}";
        bs-hl-color = "#${palette.base08}";
        ring-ver-color = "#${palette.base09}";
        inside-ver-color = "#${palette.base09}";
        inside-color = "#${palette.base01}";
        text-color = "#${palette.base07}";
        text-clear-color = "#${palette.base01}";
        text-ver-color = "#${palette.base01}";
        text-wrong-color = "#${palette.base01}";
        text-caps-lock-color = "#${palette.base07}";
        inside-clear-color = "#${palette.base0C}";
        ring-clear-color = "#${palette.base0C}";
        inside-caps-lock-color = "#${palette.base09}";
        ring-caps-lock-color = "#${palette.base02}";
        separator-color = "#${palette.base02}";
      };
    };
  };
}
