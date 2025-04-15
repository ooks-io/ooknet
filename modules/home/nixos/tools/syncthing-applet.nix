{
  osConfig,
  pkgs,
  lib,
  ook,
  ...
}: let
  inherit (lib) mkIf;
  inherit (ook.lib.services) mkTrayService;
  inherit (osConfig.ooknet.host) syncthing;
in {
  config = mkIf syncthing.enable {
    systemd.user.services."syncthing-applet" = mkTrayService "${pkgs.syncthingtray-minimal}/bin/syncthingtray --wait";
  };
}
