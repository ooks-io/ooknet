{
  config,
  lib,
  ook,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (ook.lib.container) mkContainerLabel;
  inherit (config.ooknet.server) services;
  inherit (config.ooknet.server.authentik) domain port stateDir postgres;
in {
  config = mkIf (elem "authentik" services) {
    virtualisation.oci-containers.containers = {
      authentik-server = {
        image = "ghcr.io/goauthentik/server:2025.8.4";
        autoStart = true;
        hostname = "authentik-server";
        cmd = ["server"];
        ports = [
          "${toString port}:9000"
          "9443:9443"
        ];
        volumes = [
          "${stateDir}/media:/media"
          "${stateDir}/custom-templates:/templates"
        ];
        labels = mkContainerLabel {
          name = "auth";
          inherit domain port;
          homepage = {
            group = "infrastructure";
            description = "SSO & Identity Provider";
          };
        };
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
    users.users.authentik = {
      isSystemUser = true;
      group = "authentik";
    };
    users.groups.authentik = {};
  };
}
