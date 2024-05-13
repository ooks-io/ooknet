{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland.extras.hyprcapture;
in

{
  config = lib.mkIf cfg.enable {

    home.packages = with inputs; [
    # Screenshot tool
      hyprland-contrib.packages.${pkgs.system}.grimblast
    # Screen recording tool
      ooks-scripts.packages.${pkgs.system}.hyprrecord
    ];

    # Add XDG user directories that the scripts use
    xdg.userDirs.extraConfig = {
      XDG_RECORDINGS_DIR = "${config.xdg.userDirs.videos}/Recordings";
      XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
    };

    wayland.windowManager.hyprland.settings.bind = [
      # Screenshot binds
      ",               Print,         exec,     grimblast --notify --cursor copysave area"
      "SUPER,          Print,         exec,     grimblast --notify --cursor copysave screen"
      # Recording binds
      "SUPER,          r,             exec,     hyprrecord -a -w video screen copysave"
      "SUPER CTRL,     r,             exec,     hyprrecord -a -w video area copysave"
      "SUPER ALT,      r,             exec,     hyprrecord -w gif area copysave"
    ];
  };
}
