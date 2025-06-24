{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.workstation.silentBoot;
in {
  config = mkIf cfg.enable {
    boot = {
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      consoleLogLevel = 3;
      plymouth = {
        enable = true;
        theme = "catppuccin-mocha";
        themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
      };
    };
  };
}
