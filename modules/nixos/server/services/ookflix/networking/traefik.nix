{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ../lib.nix {inherit self lib config;};
  inherit (ookflixLib) mkServiceUser mkServiceSecret mkServiceStateDir mkServiceStateFile;
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerEnvironment mkContainerLabel mkContainerPort;
  inherit (config.ooknet) server;
  inherit (config.ooknet.server.ookflix.services) traefik;
  inherit (config.ooknet.host) admin;
in {
  config = mkIf traefik.enable {
    users = mkServiceUser traefik.user.name;
    systemd.tmpfiles.settings = {
      traefikStateDir = mkServiceStateDir "traefik";
      traefikAcmeFile = mkServiceStateFile "traefik" "acme.json";
    };
    age.secrets = mkServiceSecret "cf_creds" "traefik";
    virtualisation.oci-containers.containers = {
      # vpn container
      traefik = mkIf traefik.enable {
        autoStart = true;
        image = "traefik:3.0";
        # should make this an option.
        volumes = [
          "/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${traefik.stateDir}/acme.json:/acme.json"
        ];
        ports = [
          "80:80"
          "443:443"
          (mkContainerPort traefik.port)
        ];
        environmentFiles = [config.age.secrets.cf_creds.path];
        extraOptions = ["--security-opt=no-new-privileges:true"];
        cmd = [
          "--log.level=DEBUG"
          "--api.insecure=true"
          "--api.dashboard=true"
          "--providers.docker=true"
          "--providers.docker.exposedbydefault=false"

          "--certificatesresolvers.letsencrypt.acme.email=${admin.email}"
          "--certificatesresolvers.letsencrypt.acme.storage=/acme.json"
          "--certificatesresolvers.letsencrypt.acme.dnschallenge=true"
          "--certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare"

          "--entrypoints.web.address=:80"
          "--entrypoints.websecure.address=:443"
          "--entrypoints.traefik.address=:${toString traefik.port}"

          "--entrypoints.websecure.forwardedHeaders.trustedIPs=103.21.244.0/22,103.22.200.0/22,103.31.4.0/22" # Cloudflare IPs

          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entrypoints.web.http.redirections.entrypoint.scheme=https"

          "--entrypoints.websecure.http.tls=true"
          "--entrypoints.websecure.http.tls.certResolver=letsencrypt"
          "--entrypoints.websecure.http.tls.domains[0].main=${server.domain}"
          "--entrypoints.websecure.http.tls.domains[0].sans=*.${server.domain}"
        ];

        labels = mkContainerLabel {
          name = "traefik";
          inherit (traefik) domain port;
          homepage = {
            group = "proxy";
            description = "reverse proxy";
          };
        };

        environment = mkContainerEnvironment traefik.user.id traefik.group.id;
      };
    };
  };
}
