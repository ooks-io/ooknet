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
    };

    name = mkOption {
      type = nullOr str;
      default = null;
      description = "CPU Model Name";
      example = "Intel(R) Core(TM) i3-10100 CPU @ 3.60GHz";
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

    cores = mkOption {
      type = int;
      description = "Number of Physical CPU cores the system has";
    };

    threadsPerCore = mkOption {
      type = int;
      default = 1;
      descrpition = "Number of threads per physical core (hyperthreading)";
    };

    totalThreads = mkOption {
      type = int;
      default = cfg.cpu.cores * cfg.cpu.threadsPerCore;
      description = "Number of cpu threads the cpu has";
      readOnly = true;
    };

    cache = {
      l1i = mkOption {
        type = nullOr int;
        default = null;
        description = "Size of L1 instruction cache in KiB";
        example = 192;
      };
      l1d = mkOption {
        type = nullOr int;
        default = null;
        description = "Size of L1 data cache in KiB";
        example = 192;
      };
      l2 = mkOption {
        type = nullOr int;
        default = null;
        description = "Size of L2 cache in MiB";
        example = 6;
      };
      l3 = mkOption {
        type = nullOr int;
        default = null;
        description = "Size of L3 cache in MiB";
        example = 32;
      };
    };

    microArchitecture = mkOption {
      type = str;
      default = lookupMicroArch cfg;
      description = "CPU microarchitecture (e.g, skylake, zen4)";
      readOnly = true;
    };

    amd.pstate.enable = mkEnableOption "";
  };
}
