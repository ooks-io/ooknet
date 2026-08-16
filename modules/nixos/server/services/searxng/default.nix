{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  config = mkIf (elem "searxng" services) {
    # tailnet-only: no reverse proxy, no public exposure
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [8888];

    services.searx = {
      enable = true;
      settings = {
        server = {
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
  };
}
