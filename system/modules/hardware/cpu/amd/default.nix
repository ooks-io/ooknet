{ lib, config, pkgs, ... }:

let
  inherit (lib) mkMerge mkEnableOption mkIf versionAtLeast versionOlder;
  hardware = config.systemModules.hardware.cpu; 
  cfg = hardware.amd;
  kernelVersion = config.kernelPackages.kernel.version;
  kernelVersionAtLeast = versionAtLeast kernelVersion;
  kernelVersionOlder= versionOlder kernelVersion;
in

{
  options.systemModules.hardware.cpu.amd = {
    pstate.enable = mkEnableOption "Enable pstate amd module";
  };

  config = mkIf (builtins.elem hardware.type ["amd"]) {
    environment.systemPackages = [pkgs.amdctl];
    hardware.cpu.amd.updateMicrocode = true;
    boot = mkMerge [
      {
        kernelModules = [
          "amd-pstate"
          "amd-kvm" # virtulization
          "msr" # required for amdctl
        ];
      }
      
      (mkIf (cfg.pstate.enable && (kernelVersionAtLeast "5.27") && (kernelVersionOlder "6.1")) {
        kernelParams = ["initcall_blacklist-acpi_cpufreq_init"];
        kernelModules = ["amd-pstate"];
      })

      (mkIf (cfg.pstate.enable && (kernelVersionAtLeast "6.1") && (kernelVersionOlder "6.3")) {
        kernelParams = ["amd_pstate=passive"];
      })

      (mkIf (cfg.pstate.enable && (kernelVersionAtLeast "6.3")) {
        kernelParams = ["amd_pstate=active"];
      })
    ];
  };
}
