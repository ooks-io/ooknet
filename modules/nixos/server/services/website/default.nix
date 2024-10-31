{
  lib,
  config,
  self',
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
  inherit (self'.packages) website;
in {
  config = mkIf (elem "website" services) {
    users.groups.www = {};

    systemd.tmpfiles.rules = [
      "d /var/www 0775 caddy www"
      "d /var/www/ooknet.org 0775 caddy www"
    ];

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
      enable = true;
      group = "www";

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


              Referrer-Policy: no-referrer
            }

            root * /var/www/ooknet.org/
            file_server
          '';
        "www.ooknet.org".extraConfig = ''
          redir https://ooknet.org{uri}
        '';
      };
    };
  };
}
