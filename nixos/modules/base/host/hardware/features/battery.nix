
{ lib, config, pkgs, ... }:

let
  features = config.ooknet.host.hardware.features;
  cfg = config.ooknet.host.hardware.battery;
  inherit (lib) mkIf mkDefault;
  inherit (builtins) elem;
  MHz = x: x * 1000;
in
  
{
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
