{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services domain;
  inherit (config.ooknet.server.ookflix.services) traefik;

  # traefik only watches docker labels; searxng is a native service, so its
  # route ships as a file-provider fragment mounted into the container
  searxngRoute = (pkgs.formats.yaml {}).generate "searxng-route.yml" {
    http = {
      routers.searxng = {
        rule = "Host(`search.${domain}`)";
        entryPoints = ["websecure"];
        service = "searxng";
      };
      services.searxng.loadBalancer.servers = [
        {url = "http://host.containers.internal:8888";}
      ];
    };
  };
in {
  config = mkIf (elem "searxng" services) {
    networking.firewall.interfaces = {
      # direct tailnet access (and web_search fallback url)
      "tailscale0".allowedTCPPorts = [8888];
      # traefik reaches the host service from podman's bridge networks
      "podman+".allowedTCPPorts = [8888];
    };

    services.searx = {
      enable = true;
      settings = {
        server = {
          base_url = "https://search.${domain}/";
          bind_address = "0.0.0.0";
          port = 8888;
          # only signs image-proxy/csrf urls, instance is tailnet-only
          secret_key = "eBqPFVmSNXlAgJKZIz0DHTt3c7WUdRw1";
          limiter = false;
          public_instance = false;
        };
        # json format is consumed by ook-pi's web_search tool
        search.formats = ["html" "json"];
      };
    };

    # search.${domain} rides the ookflix traefik: its wildcard *.${domain}
    # cert already covers the name, and the dns record points at the
    # tailscale address so the route is tailnet-only despite public dns.
    # future file-provider routes should mount into /dynamic and must not
    # repeat the --providers.file.directory flag.
    virtualisation.oci-containers.containers.traefik = mkIf traefik.enable {
      volumes = ["${searxngRoute}:/dynamic/searxng.yml:ro"];
      cmd = ["--providers.file.directory=/dynamic" "--providers.file.watch=false"];
    };
  };
}
