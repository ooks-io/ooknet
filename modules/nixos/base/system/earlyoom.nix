{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.system) earlyoom;
in {
  config = mkIf earlyoom.enable {
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
      enableNotifications = true;

      # prefer killing the biggest memory hogs in userspace,
      # avoid taking out system-critical stuff
      extraArgs = [
        "--prefer"
        "^(Xwayland|steam|Web Content|Isolated Web Co|electron|chromium|zen)"
        "--avoid"
        "^(Hyprland|pipewire|wireplumber|systemd|sshd)"
      ];
    };
  };
}
