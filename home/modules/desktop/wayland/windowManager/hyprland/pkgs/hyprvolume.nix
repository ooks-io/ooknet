{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "hyprvolume";
  runtimeInputs = with pkgs; [pamixer libnotify];
  text = ''
    if [ "$1" == "up" ]; then
      pamixer --increase 5
    elif [ "$1" == "down" ]; then
      pamixer --decrease 5
    elif [ "$1" == "mute" ]; then
      pamixer --toggle-mute
    fi

    VOLUME=$(pamixer --get-volume-human)

    notify-send --app-name="system-notify" -h string:x-canonical-private-synchronous:sys-notify "  $VOLUME"
  '';
}
