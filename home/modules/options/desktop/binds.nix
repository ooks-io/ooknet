{ lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (types) str;
  mkWarn = message: "notify-send --urgency=normal 'warning' '${message}'";
in

{
  options.ooknet.binds = {
    browser = mkOption {
      type = str;
      default = mkWarn "No browser is enabled";
    };

    terminal = mkOption {
      type = str;
      default = mkWarn "No terminal is enabled";
    };

    terminalLaunch = mkOption {
      type = str;
      default = mkWarn "Failed to launch tui";
    };

    fileManager = mkOption {
      type = str;
      default = mkWarn "No file manager is enabled.";
    };

    notes = mkOption {
      type = str;
      default = mkWarn "No notes app is enabled";
    };

    discord = mkOption {
      type = str;
      default = mkWarn "No discord app is enabled";
    };

    steam = mkOption {
      type = str;
      default = mkWarn "Steam is not enabled";
    };

    powerMenu = mkOption {
      type = str;
      default = mkWarn "No power menu is enabled";
    };

    locker = mkOption {
      type = str;
      default = mkWarn "No screen locker enabled";
    };
  };
}
