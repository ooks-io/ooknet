{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.ooknet.hardware) gpu;
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
in {
  config = mkIf (gpu.type == "intel") {
    services.xserver.videoDrivers = ["modesetting"];
    hardware.graphics = {
      extraPackages = attrValues {
        inherit
          (pkgs)
          intel-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
          intel-compute-runtime
          intel-media-driver
          ;
      };
      extraPackages32 = attrValues {
        inherit
          (pkgs.pkgsi686Linux)
          intel-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
          intel-media-driver
          ;
      };
    };
    boot.initrd.kernelModules = ["i915"];
    environment.variables = mkIf config.hardware.graphics.enable {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
