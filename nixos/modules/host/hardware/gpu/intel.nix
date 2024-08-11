{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.ooknet.host.hardware) gpu;
  inherit (lib) mkIf;
  inherit (builtins) elem;
  # vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
in {
  config = mkIf (elem gpu.type ["intel"]) {
    services.xserver.videoDrivers = ["modesetting"];
    hardware.graphics = {
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl

        intel-compute-runtime
        intel-media-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl

        intel-media-driver
      ];
    };
    boot.initrd.kernelModules = ["i915"];
    environment.variables = mkIf config.hardware.graphics.enable {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
