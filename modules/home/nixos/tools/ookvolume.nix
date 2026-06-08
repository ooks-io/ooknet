{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig.ooknet.hardware) features;
  ookvolume = pkgs.writeShellApplication {
    name = "ookvolume";
    runtimeInputs = with pkgs; [pamixer];
    # OSD is handled by ookshell (driven off pipewire), no notify-send needed
    text = ''
      case "$1" in
      up) pamixer --increase 5 ;;
      down) pamixer --decrease 5 ;;
      mute) pamixer --toggle-mute ;;
      *) echo "Invalid option" ;;
      esac
    '';
  };
in {
  config = mkIf (elem "audio" features) {
    home.packages = [ookvolume];
    ooknet.binds.volume = {
      up = "ookvolume up";
      down = "ookvolume down";
      mute = "ookvolume mute";
    };
  };
}
