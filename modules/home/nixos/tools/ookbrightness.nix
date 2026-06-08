{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig.ooknet.hardware) features;
  ookbrightness = pkgs.writeShellApplication {
    name = "ookbrightness";
    runtimeInputs = with pkgs; [brillo];
    # OSD is handled by ookshell (watches the backlight sysfs), no notify-send
    text =
      /*
      bash
      */
      ''
        case "$1" in
        up) brillo -q -u 30000 -A 5 ;;
        down) brillo -q -u 30000 -U 5 ;;
        *) echo "Invalid argument" ;;
        esac
      '';
  };
in {
  config = mkIf (elem "backlight" features) {
    home.packages = [ookbrightness];
    ooknet.binds.brightness = {
      up = "ookbrightness up";
      down = "ookbrightness down";
    };
  };
}
