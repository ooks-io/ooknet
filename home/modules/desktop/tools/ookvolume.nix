{ lib, pkgs, osConfig, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  features = osConfig.ooknet.host.hardware.features;
  ookvolume = pkgs.writeShellApplication {
    name = "ookvolume";
    runtimeInputs = with pkgs; [pamixer libnotify];
    text = ''
      notify() {
        volume=$(pamixer --get-volume-human)
        notify-send --app-name="system-notify" -h string:x-canonical-private-synchronous:sys-notify "󰕾 $volume"
      }
      option() {
        case "$1" in
        up)
          pamixer --increase 5
          ;;
        down)
          pamixer --decrease 5
          ;;
        mute)
          pamixer --toggle-mute
          ;;
        *) echo "Invalid option" ;;
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
  config = mkIf (elem "audio" features) {
    home.packages = [ ookvolume ];
    ooknet.binds.volume = {
      up = "ookvolume up";
      down = "ookvolume down";
      mute = "ookvolume mute";
    };
  };
}
