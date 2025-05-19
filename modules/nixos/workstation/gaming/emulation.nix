{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    services.udev = {
      packages = [
        pkgs.dolphin-emu
      ];
      extraRules = ''
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      '';
    };
    boot.extraModulePackages = [
      config.boot.kernelPackages.gcadapter-oc-kmod
    ];

    # to autoload at boot:
    boot.kernelModules = [
      "gcadapter_oc"
    ];
  };
}
