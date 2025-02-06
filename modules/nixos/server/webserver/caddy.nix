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
    services.caddy = mkMerge [
      {
        enable = true;
        group = "www";
      }

      (mkIf caddy.cloudflare.enable {
        package = pkgs.caddy.withPlugins {
          plugins = [
            "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"
            "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
          ];
          hash = "sha256-TPKNr1vzD9a1fvQM7nGYwey/i+SKGmDr/9yC+Iosd6A";
        };
        globalConfig = ''
          servers {
            metrics
            trusted_proxies static private_ranges 173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 141.101.64.0/18 108.162.192.0/18 190.93.240.0/20 188.114.96.0/20 197.234.240.0/22 198.41.128.0/17 162.158.0.0/15 104.16.0.0/13 104.24.0.0/14 172.64.0.0/13 131.0.72.0/22
          }
        '';
      })
    ];
  };
}
