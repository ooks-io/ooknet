{ config, lib, pkgs, ... }:

let
  gpu = config.systemModules.hardware.gpu;
  inherit (lib) mkIf mkDefault;
  inherit (builtins) elem;
in

{
  config = mkIf (elem gpu.type ["amd"]) {
    hardware.opengl = {
      extraPackages = with pkgs; [
        vulkan-tools
        vulkan-loader
        vulkan-extension-layer
        vulkan-validation-layers
        # amdvlk
        mesa
      ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
    boot = {
      initrd.kernelModules = ["amdgpu"];
      kernelModules = ["amdgpu"];
    };
    environment.systemPackages = [ pkgs.nvtopPackages.amd ];
    services.xserver.videoDrivers = mkDefault ["modesetting" "amdgpu"];
  };
}
