{ lib, config, ... }:

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "float,move 191 15,size 924 396,class:^(1Password)$"

        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "workspace 4, title:^(Vesktop)$"

        # Floating BTOP
        "float,title:^(BTOP)$"
        "size 85%,title:^(BTOP)$"
        "pin,title:^(BTOP)$"
        "center,title:^(BTOP)$"
        "stayfocused,title:^(BTOP)$"

        # Tearing
        "immediate, title:^(TEKKEN™8)$" 
      ];
    };
  };
}
