{
  config,
  lib,
  pkgs,
  self',
  ...
}: let
  inherit (lib) mkIf findFirst optional;
  inherit (config.ooknet.appearance) fonts;
  inherit (config.ooknet.hardware) monitors;
  cfg = config.ooknet.workstation.silentBoot;

  # fbcon/plymouth default to the edid preferred mode (60hz here) and hyprland
  # then modesets to the configured refresh, which makes the monitor resync to
  # black. asking the kernel for the same mode up front avoids that
  primary = findFirst (m: m.primary) null monitors;
  videoParam = optional (primary != null) "video=${primary.name}:${toString primary.width}x${toString primary.height}@${toString primary.refreshRate}";

  # plymouth wants a single font file in the initrd
  plymouthFont = pkgs.runCommand "plymouth-font" {} ''
    cp "$(find ${fonts.monospace.package} -name '*Regular.ttf' | sort | head -1)" $out
  '';
in {
  config = mkIf cfg.enable {
    boot = {
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
      kernelParams =
        [
          "quiet"
          "splash"
          # no blinking cursor on the fbcon before plymouth takes over
          "vt.global_cursor_default=0"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ]
        ++ videoParam;
      # amdgpu prints its overdrive notice at crit right before plymouth starts,
      # only emerg/alert reach the console now, everything is in the journal
      consoleLogLevel = 2;
      plymouth = {
        enable = true;
        theme = "ook";
        themePackages = [
          (self'.packages.ook-plymouth.override {
            fontPackage = fonts.monospace.package;
            fontFamily = fonts.monospace.family;
          })
        ];
        font = plymouthFont;
      };
    };
  };
}
