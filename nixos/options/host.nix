{ lib, config, ... }:

let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) bool enum listOf int submodule nullOr str;
  hardware = config.ooknet.host.hardware;
in

{
  options.ooknet.host = {
    name = mkOption {
      type = str;
      default = "ooksgeneric";
    };
    
    type = mkOption {
      type = enum ["desktop" "laptop" "phone" "micro" "vm"];
      default = "desktop";
    };

    role = mkOption {
      type = enum ["workstation" "server"];
      default = "workstation";
    };

    profiles = mkOption {
      type = listOf (enum ["gaming" "creative" "productivity" "media-server"]);
      default = [];
    };

    admin = {
      name = mkOption {
        type = str;
        default = "ooks";
      };
      shell = mkOption {
        type = enum ["bash" "zsh" "fish"];
        default = "bash";
      };
      gitName = mkOption {
        type = str;
        default = "ooks-io";
      };
      gitEmail = mkOption {
        type = str;
        default = "ooks@protonmail.com";
      };
      sshKey = mkOption {
        type = str;
        default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
      };
      homeManager = mkEnableOption "";
    };

    hardware = {
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
      };

      features = mkOption {
        type = listOf (enum ["audio" "video" "bluetooth" "backlight" "battery" "ssd"]);  
        default = [ "ssd" ];
      };

      battery = {
        powersave = {
          minFreq = mkOption {
            type = int;
            default = 800;
            description = "Minimum frequency for powersave mode in MHz";
          };
          maxFreq = mkOption {
            type = int;
            default = 1100;
            description = "Maximum frequency for powersave mode in MHz";
          };
        };
        performance = {
          minFreq = mkOption {
            type = int;
            default = 1500;
            description = "Minimum frequency for performance mode in MHz";
          };
          maxFreq = mkOption {
            type = int;
            default = 2600;
            description = "Maximum frequency for performance mode in MHz";
          };
        };
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
            workspace = mkOption {
              type = nullOr str;
              default = null;
            };
          };
        });
        default = [ ];
      };
    };
  };

  config = {
    assertions = [{
      assertion = ((lib.length hardware.monitors) != 0) ->
        ((lib.length (lib.filter (m: m.primary) hardware.monitors)) == 1);
      message = "Exactly one monitor must be set to primary.";
    }];
  };
}
