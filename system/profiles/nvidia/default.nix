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
      package = beta;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = false;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
    };
    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
  };

  
}
