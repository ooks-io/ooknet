{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "hyprkillsession";
  text = ''
    if pgrep -x .Hyprland-wrapp >/dev/null; then

    hyprctl dispatch exit 0
    sleep 2

    if pgrep -x .Hyprland-wrapp >/dev/null; then
    killall -9 .Hyprland-wrapp
    fi
    fi
  '';
}
