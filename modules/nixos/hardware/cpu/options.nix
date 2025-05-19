{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) enum int str nullOr float;
  cfg = config.ooknet.hardware.cpu;
  microArchMapping = import ./micro-architectures;

  lookupMicroArch = cpu: let
    vendor = cpu.type;
    family = toString cpu.model.family;
    model = toString cpu.model.id;
  in
    microArchMapping.${vendor}.${family}.${model} or null;
in {
  options.ooknet.hardware.cpu = {
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
        default = lookupMicroArch cfg;
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
          if cfg.spec.sockets == null || cfg.spec.coresPerSocket == null
          then null
          else (cfg.cpu.spec.coresPerSocket * cfg.cpu.spec.sockets) * cfg.cpu.spec.threadsPerCore;
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
}
