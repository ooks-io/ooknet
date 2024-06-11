{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  cpu = config.ooknet.host.hardware.cpu;
in

{
  # TODO: put kvm/gvt behind virtualization module flag

  config = mkIf (elem cpu.type ["intel"]) {
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["i915.fastboot=1" "enable_gvt=1"];
    };
    hardware.cpu.intel.updateMicrocode = true;
    environment.systemPackages = [pkgs.intel-gpu-tools];
  };
}
