{
  lib,
  pkgs,
  osConfig,
  config,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (inputs') hyprland-contrib;

  # grimblast save + a clean "screenshot" notification carrying the image
  ookscreenshot = pkgs.writeShellApplication {
    name = "ookscreenshot";
    runtimeInputs = [hyprland-contrib.packages.grimblast pkgs.libnotify pkgs.coreutils];
    text = ''
      dir="''${XDG_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}"
      mkdir -p "$dir"
      file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"
      grimblast copysave "''${1:-area}" "$file"
      notify-send -a screenshot \
        -h "string:image-path:file://$file" \
        -h "string:x-ookshell-edit:$file" \
        screenshot
    '';
  };
in {
  config = mkIf (environment == "hyprland") {
    home.packages = [
      # Screenshot tool
      hyprland-contrib.packages.grimblast
      ookscreenshot
      # Screenshot annotation editor (clicked from the notification)
      pkgs.satty
      # Screen recording tool
    ];

    # Add XDG user directories that the scripts use
    xdg.userDirs.extraConfig = {
      RECORDINGS = "${config.xdg.userDirs.videos}/Recordings";
      SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
    };

    wayland.windowManager.hyprland.extraLuaFiles.binds.content = ''
      -- capture
      hl.bind("Print", hl.dsp.exec_cmd("ookscreenshot area"))
      hl.bind("SUPER + Print", hl.dsp.exec_cmd("ookscreenshot screen"))
      hl.bind("SUPER + r", hl.dsp.exec_cmd("hyprrecord -a -w video screen copysave"))
      hl.bind("SUPER + CTRL + r", hl.dsp.exec_cmd("hyprrecord -a -w video area copysave"))
      hl.bind("SUPER + ALT + r", hl.dsp.exec_cmd("hyprrecord -w gif area copysave"))
    '';
  };
}
