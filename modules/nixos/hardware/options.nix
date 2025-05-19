{
  lib,
  config,
  ...
}: let
  inherit (builtins) filter length head;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum bool submodule listOf int str;

  cfg = config.ooknet.hardware;
  hasMonitors = length cfg.monitors != 0;
  primaryAttr = filter (m: m.primary or false) cfg.monitors;
  primaryCount = length primaryAttr;
in {
  options.ooknet.hardware = {
    gpu = {
      type = mkOption {
        type = nullOr (enum ["intel" "amd" "nvidia"]);
        default = null;
      };
      lact.enable = mkEnableOption "Enable amd tuning software lact";
      benchmark.enable = mkEnableOption "Enable benchmarking tools";
    };

    features = mkOption {
      type = listOf (enum [
        "audio"
        "video"
        "bluetooth"
        "backlight"
        "battery"
        "ssd"
        "printing"
        "fingerprint"
      ]);
      default = ["ssd"];
    };

    # monitor module inspired by misterio77
    # includes the addition of transform option
    primaryMonitor = mkOption {
      type = nullOr str;
      default =
        if !hasMonitors
        then null
        else (head primaryAttr).name;
      description = "Name of the primary monitor, derived from the monitors list";
      readOnly = true;
    };
    monitors = mkOption {
      type = listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            example = "DP-1";
          };
          primary = mkOption {
            type = bool;
            default = false;
          };
          width = mkOption {
            type = int;
            example = 1920;
          };
          height = mkOption {
            type = int;
            example = 1080;
          };
          refreshRate = mkOption {
            type = int;
            default = 60;
          };
          x = mkOption {
            type = int;
            default = 0;
          };
          y = mkOption {
            type = int;
            default = 0;
          };
          transform = mkOption {
            type = int;
            default = 0;
          };
          enabled = mkOption {
            type = bool;
            default = true;
          };
        };
      });
      default = [];
    };
  };

  config = {
    assertions = [
      {
        assertion = hasMonitors -> primaryCount == 1;
        message = "Error: config.ooknet.hardware.monitors. When monitors are configured, exactly one monitor must be designated as primary (found ${toString primaryCount} primary monitors)";
      }
    ];
  };
}
