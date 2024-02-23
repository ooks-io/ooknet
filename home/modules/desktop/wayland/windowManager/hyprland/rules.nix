{ lib, config, ... }:
let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in
{
  config = {
    wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
      windowrulev2 = [
        "float,move 191 15,size 924 396,class:(1Password)"

        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "rounding 0, xwayland:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

        "immediate, title:^(TEKKEN™8)$" #allow tearing for tekken8
      ];
    };
  };
}
