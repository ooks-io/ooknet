{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  config = mkIf (elem "authentik" services) {
    virtualisation.oci-containers.containers = {
      authentik-redis = {
        image = "docker.io/library/redis:alpine";
        autoStart = true;
        hostname = "authentik-redis";
        volumes = [
          "${config.ooknet.server.authentik.stateDir}/redis:/data"
        ];
        cmd = ["--save" "60" "1" "--loglevel" "warning"];
        networks = [
          "authentik"
        ];
        extraOptions = [
          "--health-cmd=redis-cli ping | grep PONG"
          "--health-interval=30s"
          "--health-timeout=3s"
          "--health-retries=5"
          "--health-start-period=20s"
        ];
      };
    };
  };
}
