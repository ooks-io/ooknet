{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf getExe elem;
  inherit (config.ooknet.server) services;
  inherit (config.virtualisation) podman;
in {
  config = mkIf (elem "authentik" services) {
    systemd.services.podman-network-authentik = {
      description = "Podman network authentik";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${getExe podman.package} network create -d bridge authentik";
        ExecStop = "${getExe podman.package} network rm -f authentik";
      };
      wantedBy = ["multi-user.target"];
      before = [
        "podman-authentik-server.service"
        "podman-authentik-worker.service"
        "podman-authentik-postgres.service"
        "podman-authentik-redis.service"
      ];
    };

    systemd.tmpfiles.settings.authentik = {
      "${config.ooknet.server.authentik.stateDir}"."d" = {
        mode = "0755";
      };
      "${config.ooknet.server.authentik.stateDir}/media"."d" = {
        mode = "0755";
      };
      "${config.ooknet.server.authentik.stateDir}/certs"."d" = {
        mode = "0755";
      };
      "${config.ooknet.server.authentik.stateDir}/custom-templates"."d" = {
        mode = "0755";
      };
      "${config.ooknet.server.authentik.stateDir}/database"."d" = {
        mode = "0755";
      };
      "${config.ooknet.server.authentik.stateDir}/redis"."d" = {
        mode = "0755";
      };
    };
  };
}
