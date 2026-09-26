{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
