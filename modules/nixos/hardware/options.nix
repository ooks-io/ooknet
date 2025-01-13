{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum bool submodule listOf int str;
  inherit (config.ooknet) hardware;
in {
  options.ooknet.hardware = {
    gpu = {
      type = mkOption {
        type = nullOr (enum ["intel" "amd" "nvidia"]);
        default = null;
      };
    };

    cpu = {
      type = mkOption {
        type = nullOr (enum ["intel" "amd"]);
        default = null;
      };
      amd.pstate.enable = mkEnableOption "";
      cores = {
        type = int;
        description = "Number of Physical CPU cores the system has";
      };
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
          workspace = mkOption {
            type = nullOr str;
            default = null;
          };
        };
      });
      default = [];
    };
  };

  config = {
    assertions = [
      {
        assertion =
          ((lib.length hardware.monitors) != 0)
          -> ((lib.length (lib.filter (m: m.primary) hardware.monitors)) == 1);
        message = "At least 1 primary monitor is required";
      }
    ];
  };
}
