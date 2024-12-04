{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (config.ooknet.server) ookflix;
  inherit (config.virtualisation) podman;
  podmanCommand = getExe podman.package;
in {
  config = mkIf ookflix.enable {
    systemd.services = {
      "podman-ookflix-network" = {
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          SyslogIdentifier = "%N";
        };
        unitConfig = {
          "RequiresMountsFor" = "%t/containers";
        };
        wantedBy = ["multi-user.target"];
        script = "${podmanCommand} network create --ignore --driver=bridge ookflix";
      };
    };
  };
}
