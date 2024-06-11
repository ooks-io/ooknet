{ lib, config, pkgs, ... }:

let
  inherit (lib) mkMerge mkIf versionAtLeast versionOlder;
  inherit (builtins) elem;
  cpu = config.ooknet.host.hardware.cpu; 
  cfg = cpu.amd;
  kernelVersion = config.boot.kernelPackages.kernel.version;
  kernelVersionAtLeast = versionAtLeast kernelVersion;
  kernelVersionOlder= versionOlder kernelVersion;
in

{
  config = mkIf (elem cpu.type ["amd"]) {
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
