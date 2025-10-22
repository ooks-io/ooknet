{
  lib,
  config,
  self',
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
  inherit (self'.packages) website;

  websitePermissions = {
    group = "www";
    user = "caddy";
    mode = "0775";
  };
in {
  config = mkIf (elem "website" services) {
    ooknet.server.webserver.caddy = {
      enable = true;
      cloudflare.enable = true;
    };
    systemd.tmpfiles.settings.websiteDirs = {
      "/var/www"."d" = websitePermissions;
      "/var/www/ooknet.org"."d" = websitePermissions;
    };

    # cursed activation script
    # need to find a better way

    system.activationScripts.copyWebsite = {
      text =
        # sh
        ''
          # clean-up
          rm -rf /var/www/ooknet.org/*

          # ensure dir exists
          mkdir -p /var/www/ooknet.org

          # copy files from pkg
          cp -r ${website}/* /var/www/ooknet.org/

          # set permissions
          chown -R caddy:www /var/www/ooknet.org
          chmod -R 775 /var/www/ooknet.org
        '';
      deps = ["users" "groups"];
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

            root * /var/www/ooknet.org/
            file_server
          '';
        "www.ooknet.org".extraConfig = ''
          redir https://ooknet.org{uri} permanent
        '';
      };
    };
  };
}
