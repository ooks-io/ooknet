{ lib, pkgs, ... }:

let
  mkBind = message: lib.mkOption {
    type = lib.types.str;
    default = "${pkgs.libnotify}/bin/notify-send --urgency=normal 'Warning' '${message}'";
  };
in

{
  options.ooknet.binds = {
    browser = mkBind "No browser is enabled";
    terminal = mkBind "No terminal is enabled";
    terminalLaunch = mkBind "Failed to launch tui";
    fileManager = mkBind "No file manager is enabled.";
    notes = mkBind "No Notes app is enabled";
    discord = mkBind "No Discord app is enabled";
    steam = mkBind "Steam is not enabled";
    powerMenu = mkBind "No power menu is enabled";
    lock = mkBind "No screen locker enabled";
    password = mkBind "No password manager enabled";
    zellijMenu = mkBind "Zellij Menu is not enabled";
    volume = {
      up = mkBind "Volume binding not found...";
      down = mkBind "Volume binding not found...";
      mute = mkBind "Volume binding not found...";
    };
    brightness = {
      up = mkBind "Brightness binding not found...";
      down = mkBind "Brightness binding not found...";
    };
    spotify = {
      launch = mkBind "Spotify is not enabled";
      next = mkBind "Spotify is not enabled";
      previous = mkBind "Spotify is not enabled";
      play = mkBind "Spotify is not enabled";
    };
  };
}
