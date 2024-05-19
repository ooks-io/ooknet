{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "hyprbrightness";
  runtimeInputs = with pkgs; [brillo libnotify];
  text = ''
    if [ "$1" == "up" ]; then
      brillo -q -u 30000 -A 5
    elif [ "$1" == "down" ]; then
      brillo -q -u 30000 -U 5
    else
      echo "Invalid argument"
      exit 1
    fi

    BRIGHTNESS=$(brillo -G | awk -F'.' '{print$1}')

    notify-send --app-name="system-notify" -h string:x-canonical-private-synchronous:sys-notify "󰃠  $BRIGHTNESS%"
  '';
}
