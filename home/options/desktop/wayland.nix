{ lib, ... }:

let
  inherit (lib) mkOption mkEnableOption types;
  inherit (types) nullOr enum;
in

{
  options.ooknet.wayland = {
    enable = mkEnableOption "";
    compositor = mkOption {
      type = nullOr (enum [ "hyprland" ]);
    };
    launcher = mkOption {
      type = nullOr (enum [ "rofi" "tofi" ]);
      default = null;
    };
    locker = mkOption {
      type = nullOr (enum [ "hyprlock" "swaylock" ]);
      default = null;
    };
    notification = mkOption {
      type = nullOr (enum [ "mako" ]);
      default = null;
    };
    bar = mkOption {
      type = nullOr (enum [ "waybar" ]);
      default = null;
    };
  };
}
