{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
  inherit (config.ooknet.server.authentik) stateDir postgres;
in {
  config = mkIf (elem "authentik" services) {
    virtualisation.oci-containers.containers = {
      authentik-worker = {
        image = "ghcr.io/goauthentik/server:2025.8.4";
        autoStart = true;
        hostname = "authentik-worker";
        cmd = ["worker"];
        user = "root";
        volumes = [
          "${stateDir}/media:/media"
          "${stateDir}/certs:/certs"
          "${stateDir}/custom-templates:/templates"
          "/var/run/podman/podman.sock:/var/run/docker.sock"
        ];
        environment = {
          AUTHENTIK_REDIS__HOST = "authentik-redis";
          AUTHENTIK_POSTGRESQL__HOST = "authentik-postgres";
          AUTHENTIK_POSTGRESQL__NAME = postgres.database;
          AUTHENTIK_POSTGRESQL__USER = postgres.user;
        };
        environmentFiles = [
          config.age.secrets.authentik-env.path
        ];
        dependsOn = ["authentik-postgres" "authentik-redis"];
        networks = ["authentik"];
      };
    };
  };
}
