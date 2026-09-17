{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config.ooknet.hardware) features;
in {
  config = mkIf (elem "peripherals" features) {
    # hidraw access for webhid config tools (hub.rapoo.com in chromium).
    # must sort before systemd's 73-seat-late.rules or the uaccess tag is
    # never acted on, so this cant go in extraRules (99-local.rules)
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "peripherals-udev-rules";
        destination = "/etc/udev/rules.d/70-peripherals.rules";
        text = ''
          # rapoo
          KERNEL=="hidraw*", ATTRS{idVendor}=="24ae", TAG+="uaccess"
        '';
      })
    ];
  };
}
