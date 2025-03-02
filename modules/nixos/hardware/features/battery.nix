{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem attrValues;
  inherit (config.ooknet.hardware) features;
in {
  config = mkIf (elem "battery" features) {
    services = {
      # cpu power usage optimizer
      auto-cpufreq.enable = true;
      power-profiles-daemon.enable = false;

      # application interface for power management
      upower = {
        enable = true;
        percentageLow = 25;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };

      # daemon for monitoring and controlling temperature
      thermald = {enable = true;};

      # put this here because if we are enabling the battery modules
      # we are most likely using a laptop
      # lidSwitch defines the action to perform when the laptop lid is
      # closed
      logind = {lidSwitch = "suspend";};
    };
    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = attrValues {
        inherit (config.boot.kernelPackages) acpi_call cpupower;
      };
    };
    environment.systemPackages = attrValues {
      inherit (pkgs) acpi powertop;
    };
  };
}
