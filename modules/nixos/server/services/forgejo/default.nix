{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet.server) services domain;
  inherit (lib) mkIf elem;
in {
  config = mkIf (elem "forgejo" services) {
    networking.firewall.allowedTCPPorts = [2222];

    ooknet.server = {
      webserver.caddy.enable = true;
      database.postgresql.enable = true;
    };
    services = {
      forgejo = {
        enable = true;

        settings = {
          server = {
            DOMAIN = "git.${domain}";
            ROOT_URL = "https://git.${domain}";
            HTTP_PORT = 3000;
            LANDING_PAGE = "explore";

            START_SSH_SERVER = true;
            SSH_PORT = 2222;
            SSH_LISTEN_PORT = 2222;
          };
          database = {
            type = "postgres";
            createDatabase = true;
          };
          service = {
            DISABLE_REGISTRATION = true;
          };
          security = {
            INSTALL_LOCK = true;
          };
        };
      };
      caddy.virtualHosts = {
        "git.${domain}".extraConfig = ''
          header {
            Strict-Transport-Security "max-age=31536000;"
            X-XSS-Protection "1; mode=block"
            X-Frame-Options "DENY"
            X-Content-Type-Options "nosniff"
            -Server
            Referrer-Policy "no-referrer"
          }

          # Handle proxying
          handle_path /* {
            reverse_proxy localhost:3000 {
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}
            }
          }
        '';
      };
    };
  };
}
