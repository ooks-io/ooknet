{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.ooknet.hardware) gpu;
  inherit (lib) mkMerge mkIf mkDefault;
  inherit (builtins) attrValues;
in {
  config = mkIf (gpu.type == "amd") (mkMerge [
    {
      hardware.amdgpu = {
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
      };
      boot = {
        initrd.kernelModules = ["amdgpu"];
        kernelModules = ["amdgpu"];
      };
      environment.systemPackages = [pkgs.nvtopPackages.amd];
      services.xserver.videoDrivers = mkDefault ["modesetting" "amdgpu"];
    }
    (mkIf gpu.lact.enable {
      boot.kernelParams = ["amdgpu.ppfeaturemask=0xfffd7fff"];
      environment.systemPackages = [pkgs.lact];

      systemd = {
        packages = [pkgs.lact];
        services.lactd = {
          wantedBy = ["multi-user.target"];
          unitConfig = {
            Description = "GPU Control Daemon";
            After = ["multi-user.target"];
          };
        };
      };
    })
  ]);
}
