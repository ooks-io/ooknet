{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (config.ooknet.server.webserver) caddy;
in {
  config = mkIf caddy.enable {
    users.groups.www = {};

    # metrics scraping via tailscale
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [2019];

    services.caddy = mkMerge [
      {
        enable = true;
        group = "www";
      }

      (mkIf caddy.cloudflare.enable {
        package = pkgs.caddy.withPlugins {
          plugins = [
            "github.com/caddy-dns/cloudflare@v0.2.1"
            "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
            "github.com/mholt/caddy-ratelimit@v0.1.0"
          ];
          hash = "sha256-VcjByobqNnJvO3hm2LbcNYRQCsDjmZLQ7b/6B4AF7KA=";
        };
        globalConfig = ''
          admin 0.0.0.0:2019

          servers {
            metrics
            trusted_proxies static private_ranges 173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 141.101.64.0/18 108.162.192.0/18 190.93.240.0/20 188.114.96.0/20 197.234.240.0/22 198.41.128.0/17 162.158.0.0/15 104.16.0.0/13 104.24.0.0/14 172.64.0.0/13 131.0.72.0/22
          }
        '';
      })
    ];
  };
}
