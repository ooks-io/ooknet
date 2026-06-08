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

    wayland.windowManager.hyprland.settings.bind = [
      # Screenshot binds
      ",               Print,         exec,     ookscreenshot area"
      "SUPER,          Print,         exec,     ookscreenshot screen"
      # Recording binds
      "SUPER,          r,             exec,     hyprrecord -a -w video screen copysave"
      "SUPER CTRL,     r,             exec,     hyprrecord -a -w video area copysave"
      "SUPER ALT,      r,             exec,     hyprrecord -w gif area copysave"
    ];
  };
}
