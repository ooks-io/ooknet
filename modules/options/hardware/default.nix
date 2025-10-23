{
  lib,
  config,
  ...
}: let
  inherit (builtins) filter length head;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum bool submodule listOf int str float;

  cfg = config.ooknet.hardware;
  hasMonitors = length cfg.monitors != 0;
  primaryAttr = filter (m: m.primary or false) cfg.monitors;
  primaryCount = length primaryAttr;

  cpuCfg = config.ooknet.hardware.cpu;
  microArchMapping = import ../nixos/hardware/cpu/micro-architectures;

  lookupMicroArch = cpu: let
    vendor = cpu.type;
    family = toString cpu.model.family;
    model = toString cpu.model.id;
  in
    microArchMapping.${vendor}.${family}.${model} or null;
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

    cpu = {
      type = mkOption {
        type = nullOr (enum ["intel" "amd"]);
        default = null;
      };

      model = {
        id = mkOption {
          type = nullOr int;
          default = null;
          description = "CPU model from CPUID";
        };
        family = mkOption {
          type = nullOr int;
          default = null;
          description = "CPU family from CPUID";
        };
        stepping = mkOption {
          type = nullOr int;
          default = null;
          description = "CPU stepping from CPUID";
        };
        name = mkOption {
          type = nullOr str;
          default = null;
          description = "CPU Model Name";
          example = "Intel(R) Core(TM) i3-10100 CPU @ 3.60GHz";
        };
        microArchitecture = mkOption {
          type = str;
          default = lookupMicroArch cpuCfg;
          description = "CPU microarchitecture (e.g, skylake, zen4)";
          readOnly = true;
        };
      };

      spec = {
        sockets = mkOption {
          type = nullOr int;
          default = 1;
          description = "Number of CPU sockets";
        };
        baseClock = mkOption {
          type = nullOr float;
          default = null;
          description = "Base clock frequency in GHz";
          example = 3.8;
        };

        boostClock = mkOption {
          type = nullOr float;
          default = null;
          description = "Boost clock frequency in GHz";
          example = 4.7;
        };

        coresPerSocket = mkOption {
          type = nullOr int;
          default = null;
          description = "Number of Physical CPU core per socket";
        };

        threadsPerCore = mkOption {
          type = int;
          default = 1;
          description = "Number of threads per physical core (hyperthreading)";
        };

        totalThreads = mkOption {
          type = int;
          default =
            if cpuCfg.spec.sockets == null || cpuCfg.spec.coresPerSocket == null
            then null
            else (cpuCfg.cpu.spec.coresPerSocket * cpuCfg.cpu.spec.sockets) * cpuCfg.cpu.spec.threadsPerCore;
          description = "Number of cpu threads the cpu has";
          readOnly = true;
        };

        tdp = mkOption {
          type = nullOr int;
          default = null;
          description = ''
            Thermal Design Power in watts.
            Must be manually specified based on CPU model.
            Refer to manufacturer specifications:
            - Intel: https://ark.intel.com
            - AMD: https://www.amd.com/en/products/specifications.html
          '';
          example = 65;
        };

        cache = {
          l1i = mkOption {
            type = nullOr int;
            default = null;
            description = "Size of L1 instruction cache in Bytes";
            example = 192;
          };
          l1d = mkOption {
            type = nullOr int;
            default = null;
            description = "Size of L1 data cache in Bytes";
            example = 192;
          };
          l2 = mkOption {
            type = nullOr int;
            default = null;
            description = "Size of L2 cache in Bytes";
            example = 6;
          };
          l3 = mkOption {
            type = nullOr int;
            default = null;
            description = "Size of L3 cache in Bytes";
            example = 32;
          };
        };
      };

      amd.pstate.enable = mkEnableOption "";
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
