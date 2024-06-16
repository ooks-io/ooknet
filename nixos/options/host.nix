{ lib, config, ... }:

let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) bool enum listOf int submodule nullOr str;
  inherit (lib.lists) optionals concatLists;
  inherit (builtins) concatStringsSep;

  admin = config.ooknet.host.admin;
  hardware = config.ooknet.host.hardware;
  tailscale = config.ooknet.host.networking.tailscale;
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
      type = listOf (enum ["gaming" "creative" "productivity" "console-tools" "media" "media-server"]);
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
      homeManager = mkEnableOption "";
    };

    # tailscale options brought to you by github:notashelf/nyx
    networking = {
      tailscale = {
        enable = mkEnableOption "Enable tailscale system module";
        autoconnect = mkEnableOption "Enable auto connect tailscale service";
        authkey = mkOption {
          type = str;
          default = config.age.secrets.tailscale-auth.path;
        };
        server = mkOption {
          type = bool;
          default = false;
          description = "Define if the host is a server";
        };
        client = mkOption {
          type = bool;
          default = tailscale.enable;
          description = "Define if the host is a client";
        };
        tags = mkOption {
          type = listOf str;
          default = 
            if tailscale.client then ["tag:client"]
            else if tailscale.server then ["tag:server"]
            else [];
          description = "Sets host tag depending on if server/client";
        };
        operator = mkOption {
          type = str;
          default = "${admin.name}";
          description = "Name of the tailscale operator";
        };
        flags = {
          default = mkOption {
            type = listOf str;
            default = ["--ssh"];
          };
          final = mkOption {
            type = listOf str;
            internal = true;
            readOnly = true;
            default = concatLists [
              tailscale.flags.default
              (optionals (tailscale.authkey != null) ["--authkey file:${config.age.secrets.tailscale-auth.path}"])
              (optionals (tailscale.operator != null) ["--operator ${tailscale.operator}"])
              (optionals (tailscale.tags != []) ["--advertise-tags" (concatStringsSep "," tailscale.tags)])
              (optionals tailscale.server ["--advertise-exit-node"])
            ];
          };
        };
      };
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
      message = "At least 1 primary monitor is required";
    }];
  };
}
