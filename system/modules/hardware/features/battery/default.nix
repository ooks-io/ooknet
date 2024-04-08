
{ lib, config, pkgs, ... }:

let
  features = config.systemModules.hardware.features;
  cfg = config.systemModules.hardware.battery;
  inherit (lib) mkIf mkDefault mkOption types;
  inherit (builtins) elem;
  MHz = x: x * 1000;
in
  
{
  options.systemModules.hardware.battery = {
    powersave = {
      minFreq = mkOption {
        type = types.int;
        default = 800;
        description = "Minimum frequency for powersave mode in MHz";
      };
      maxFreq = mkOption {
        type = types.int;
        default = 1100;
        description = "Maximum frequency for powersave mode in MHz";
      };
    };
    performance = {
      minFreq = mkOption {
        type = types.int;
        default = 1500;
        description = "Minimum frequency for performance mode in MHz";
      };
      maxFreq = mkOption {
        type = types.int;
        default = 2600;
        description = "Maximum frequency for performance mode in MHz";
      };
    };
  };

  config = mkIf (elem "battery" features) {
    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    services = {
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            scaling_min_freq = mkDefault (MHz cfg.powersave.minFreq);
            scaling_max_freq = mkDefault (MHz cfg.powersave.maxFreq);
            turbo = "never";
          };
          charger = {
            governor = "performance";
            scaling_min_freq = mkDefault (MHz cfg.performance.minFreq);
            scaling_max_freq = mkDefault (MHz cfg.performance.maxFreq);
            turbo = "auto";
          };
        };
      };

      upower = {
        enable = true;
        percentageLow = 25;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };

      undervolt = {
        enable = true;
        tempBat = 65;
      };

      thermald.enable = true;

      power-profiles-daemon.enable = true;

      logind = {
        lidSwitch = "suspend";
      };
    };
    environment.systemPackages = with pkgs; [
      acpi
      powertop
    ];
  };
}
