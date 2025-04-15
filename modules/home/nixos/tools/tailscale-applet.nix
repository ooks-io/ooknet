{
  lib,
  pkgs,
  ook,
  ...
}: let
  inherit (ook.lib.services) mkGraphicalService;
  inherit (lib) getExe;
in {
  systemd.user.services.tailscale-applet = mkGraphicalService {
    Unit = {
      Description = "Tray applet for tailscale";
      Requires = ["tray.target"];
    };
    Service = {
      ExecStart = "${getExe pkgs.tailscale-systray}";
      Restart = "on-abort";
    };
  };
}
