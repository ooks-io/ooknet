{ lib, config, pkgs, ... }:

let
  cfg = config.systemProfile.nvidia;
  production = config.boot.kernelPackages.nvidiaPackages.production;
  beta = config.boot.kernelPackages.nvidiaPackages.beta;
in

{
  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      open = true;
      package = production;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };
    hardware.opengl.extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    services.xserver.videoDrivers = [ "nvidia" ];
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
      mesa
      
      libva
      libva-utils

      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-extension-layer
    ];
  };

  
}
