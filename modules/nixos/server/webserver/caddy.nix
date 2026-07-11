{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge concatStringsSep;
  inherit (config.ooknet.server.webserver) caddy;
  cf = import ./cloudflare-ips.nix;
in {
  config = mkIf caddy.enable {
    users.groups.www = {};

    # metrics scraping via tailscale
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [2019];

    # origin lockdown: drop direct (non-cloudflare) hits on 80/443 so the vps
    # cant be reached bypassing cloudflare. dedicated chain at higher priority
    # than the firewall (drop is terminal, and firewall extraInputRules run
    # AFTER the port accepts so a drop there wouldnt fire). lo + tailscale0
    # exempt so loopback and tailnet admin access to the web UI still work.
    networking.nftables.tables = mkIf caddy.cloudflareOnly {
      cf-origin-lock = {
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority -10; policy accept;
            iifname { "lo", "tailscale0" } accept
            tcp dport { 80, 443 } ip  saddr != { ${concatStringsSep ", " cf.v4} } drop
            tcp dport { 80, 443 } ip6 saddr != { ${concatStringsSep ", " cf.v6} } drop
          }
        '';
      };
    };

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
          hash = "sha256-TYMJtG41NgRwS4+cH2rau5KfXA0krkCFVlMZwGAnUEI=";
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
