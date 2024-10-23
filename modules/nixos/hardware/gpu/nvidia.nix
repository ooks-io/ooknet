{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.ooknet.hardware) gpu;
  inherit (lib) mkIf mkDefault;
  inherit (builtins) attrValues;
  # production = config.boot.kernelPackages.nvidiaPackages.production;
  inherit (config.boot.kernelPackages.nvidiaPackages) beta;
in {
  config = mkIf (gpu.type == "nvidia") {
    # need this even if using wayland
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
        extraPackages = [pkgs.nvidia-vaapi-driver];
        extraPackages32 = [pkgs.pkgsi686Linux.nvidia-vaapi-driver];
      };
    };
    environment.systemPackages = attrValues {
      inherit
        (pkgs)
        libva
        libva-utils
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        vulkan-extension-layer
        mesa
        ;
      inherit (pkgs.nvtopPackages) nvidia;
    };
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
