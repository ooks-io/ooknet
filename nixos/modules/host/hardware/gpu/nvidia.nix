{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.ooknet.host.hardware) gpu;
  inherit (lib) mkIf mkDefault;
  inherit (builtins) elem;
  # production = config.boot.kernelPackages.nvidiaPackages.production;
  inherit (config.boot.kernelPackages.nvidiaPackages) beta;
in {
  # TODO: make option to choose nvidia package
  config = mkIf (gpu.type == "nvidia") {
    # need this for wayland
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      nvidia = {
        open = false;
        package = beta;
        forceFullCompositionPipeline = true;
        nvidiaSettings = false;
        nvidiaPersistenced = true;
        modesetting.enable = true;
        powerManagement = {
          enable = mkDefault false;
          finegrained = mkDefault false;
        };
      };
      graphics = {
        extraPackages = with pkgs; [nvidia-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
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
    # https://github.com/ventureoo/nvidia-tweaks
    services.udev.extraRules = ''
      ACTION=="bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="on"
    '';
    boot.kernelParams = [
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_InitializeSystemMemoryAllocations=0"
      "nvidia.NVreg_EnableStreamMemOPs=1"
      "nvidia.NVreg_RegistryDwords=__REGISTRYDWORDS"
    ];
  };
}
