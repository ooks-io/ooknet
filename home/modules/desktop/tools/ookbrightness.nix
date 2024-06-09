{ lib, osConfig, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  features = osConfig.ooknet.host.hardware.features;
  ookbrightness = pkgs.writeShellApplication {
    name = "ookbrightness";
    runtimeInputs = with pkgs; [brillo libnotify];
    text = /* bash */ ''
      BRIGHTNESS=$(brillo -G | awk -F'.' '{print$1}')
      notify() {
        notify-send --app-name="system-notify" -h string:x-canonical-private-synchronous:sys-notify "󰃠  $BRIGHTNESS%"
      }
      option() {
        case "$1" in
        up)
          brillo -q -u 30000 -A 5
          ;;
        down)
          brillo -q -u 30000 -U 5
          ;;
        *)
          echo "Invalid argument"
          ;;
        esac
      }
      main() {
        option "$@"
        notify
      }
      main "$@"
    '';
  };
in

{
  config = mkIf (elem "backlight" features) {
    home.packages = [ ookbrightness ];
    ooknet.binds.brightness = {
      up = "ookbrightness up";
      down = "ookbrightness down";
    };
  };
}
