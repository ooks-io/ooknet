{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.hardware) cpu;
in {
  config = mkIf (cpu.type == "intel") {
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["i915.fastboot=1" "enable_gvt=1"];
    };
    hardware.cpu.intel.updateMicrocode = true;
    environment.systemPackages = [pkgs.intel-gpu-tools];
  };
}
