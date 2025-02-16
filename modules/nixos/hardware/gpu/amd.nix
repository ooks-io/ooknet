{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.ooknet.hardware) gpu;
  inherit (lib) mkIf mkDefault;
  inherit (builtins) attrValues;
in {
  config = mkIf (gpu.type == "amd") {
    hardware.amdgpu = {
      amdvlk = {
        enable = false;
        support32Bit.enable = true;
      };
      opencl.enable = false;
    };
    hardware.graphics = {
      extraPackages = attrValues {
        inherit
          (pkgs)
          vulkan-tools
          vulkan-loader
          vulkan-extension-layer
          vulkan-validation-layers
          mesa
          ;
      };
      extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    };
    boot = {
      initrd.kernelModules = ["amdgpu"];
      kernelModules = ["amdgpu"];
    };
    environment.systemPackages = [pkgs.nvtopPackages.amd];
    services.xserver.videoDrivers = mkDefault ["modesetting" "amdgpu"];
  };
}
