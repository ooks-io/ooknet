{ lib, config, pkgs, ... }:

let
  cfg = config.systemProfile.amd;
in

{
  config = lib.mkIf cfg.enable {

    hardware.opengl = {
      extraPackages = with pkgs; [
        vulkan-tools
        vulkan-loader
        vulkan-extension-layer
        vulkan-validation-layer
        amdvlk
        mesa
      ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    boot = {
      initrd.kernelModules = ["amdgpu"];
      kernelModules = ["amdgpu"];
    };

    environment.systemPackages = [ pkgs.nvtopPackages.amd ];
  };
}
