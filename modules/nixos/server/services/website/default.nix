{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  imports = [inputs.ooknet-org.nixosModules.ooknet-site];

  config = mkIf (elem "website" services) {
    ooknet.server.webserver.caddy = {
      enable = true;
      cloudflare.enable = true;
    };

    # push-driven builder from the ooknet-org flake: clones the site
    # from forgejo, mirrors the /git repos, builds, swaps a symlink.
    # replaces the old zola package + activation-script copy.
    services.ooknet-site = {
      enable = true;
      siteRepo = "http://localhost:3000/ooks/ooknet.org.git";
      mirrors = [
        {
          slug = "ooknet-org";
          url = "http://localhost:3000/ooks/ooknet.org.git";
        }
        {
          slug = "ooknet";
          url = "http://localhost:3000/ooks/ooknet.git";
        }
        {
          slug = "wowsim-stats";
          url = "http://localhost:3000/ooks/wowsim-stats.git";
        }
      ];
    };

    # using caddy because it makes my life easy
    services.caddy = {
      virtualHosts = {
        "ooknet.org".extraConfig =
          # sh
          ''
            encode zstd gzip

            header {
              Strict-Transport-Security "max-age=31536000;"
              X-XSS-Protection "1; mode=block"
              X-Frame-Options "DENY"
              X-Content-Type-Options "nosniff"
              -Server


              Referrer-Policy "no-referrer"
            }

            # rate limiting: 100 requests per minute per IP
            rate_limit {
              zone static {
                key {remote_host}
                events 100
                window 1m
              }
            }

            root * ${config.services.ooknet-site.webroot}
            file_server
          '';
        "www.ooknet.org".extraConfig = ''
          redir https://ooknet.org{uri} permanent
        '';
      };
    };
  };
}
