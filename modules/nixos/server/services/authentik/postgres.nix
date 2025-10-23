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
      authentik-postgres = {
        image = "docker.io/library/postgres:16-alpine";
        autoStart = true;
        hostname = "authentik-postgres";
        volumes = [
          "${stateDir}/database:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_DB = postgres.database;
          POSTGRES_USER = postgres.user;
        };
        environmentFiles = [
          config.age.secrets.authentik-env.path
        ];
        networks = [
          "authentik"
        ];
        extraOptions = [
          "--health-cmd=pg_isready -d ${postgres.database} -U ${postgres.user}"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=5"
          "--health-start-period=20s"
        ];
      };
    };
  };
}
