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
    services.udev.packages = [
      pkgs.dolphin-emu
      (pkgs.writeTextFile {
        name = "99-nintendo-controller.rules";
        text = ''
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", \
          ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", \
          MODE="0666";
        '';
        destination = "/etc/udev/rules.d/40-nintendo-controller.rules";
      })
    ];
    boot.extraModulePackages = [
      config.boot.kernelPackages.gcadapter-oc-kmod
    ];

    # to autoload at boot:
    boot.kernelModules = [
      "gcadapter_oc"
    ];
  };
}
