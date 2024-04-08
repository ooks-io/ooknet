{ config, lib, pkgs, ... }:

let
  gpu = config.systemModules.hardware.gpu;
  inherit (lib) mkIf mkDefault;
  inherit (builtins) elem;
  production = config.boot.kernelPackages.nvidiaPackages.production;
  # beta = config.boot.kernelPackages.nvidiaPackages.beta;
in

{
# TODO: make option to choose nvidia package
  config = mkIf (elem gpu.type ["nvidia"]) {
    hardware = {
      nvidia = {
        open = mkDefault true;
        package = production;
        forceFullCompositionPipeline = true;
        nvidiaSettings = false;
        nvidiaPersistenced = true;
        modesetting.enable = true;
        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault false;
        };
      };
      opengl = {
        extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
      };
    };
    environment.systemPackages = with pkgs; [

      libva
      libva-utils

      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-extension-layer

      mesa

      nvtopPackages.nvidia
    ];
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
  };
}
