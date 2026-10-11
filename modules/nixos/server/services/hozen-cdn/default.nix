# wow game file tree (hozen-cdn), tailnet only. plain http on 5001 like the
# nix cache, plus cdn.hozen.dev through the ookflix traefik: the dns record
# points at the tailscale address so the https name is tailnet-only too
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
  inherit (config.ooknet.server.ookflix.services) traefik;

  domain = "hozen.dev";
  port = 5001;

  route = (pkgs.formats.yaml {}).generate "hozen-cdn-route.yml" {
    http = {
      routers.hozen-cdn = {
        rule = "Host(`cdn.${domain}`)";
        entryPoints = ["websecure"];
        service = "hozen-cdn";
      };
      services.hozen-cdn.loadBalancer.servers = [
        {url = "http://host.containers.internal:${toString port}";}
      ];
    };
  };
in {
  config = mkIf (elem "hozen-cdn" services) {
    services.hozen-cdn = {
      enable = true;
      root = "/jellyfin/hozen-cdn";
      listen = "[::]:${toString port}";
      openFirewall.interfaces = ["tailscale0"];
    };

    # seeding (`hozen-cdn resolve`) runs on the box as the admin
    environment.systemPackages = [config.services.hozen-cdn.package];
    systemd.tmpfiles.rules = ["d /jellyfin/hozen-cdn 0755 ${config.ooknet.host.admin.name} users -"];

    networking.firewall.extraInputRules = ''iifname "podman*" tcp dport ${toString port} accept'';

    virtualisation.oci-containers.containers.traefik = mkIf traefik.enable {
      volumes = ["${route}:/dynamic/hozen-cdn.yml:ro"];
      # second cert, same cloudflare dns challenge. the token has to cover
      # the hozen.dev zone
      cmd = [
        "--entrypoints.websecure.http.tls.domains[1].main=${domain}"
        "--entrypoints.websecure.http.tls.domains[1].sans=*.${domain}"
      ];
    };
  };
}
