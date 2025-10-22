{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services domain;
  inherit (config.age) secrets;
in {
  config = mkIf (elem "authelia" services) {
    # Enable Caddy
    ooknet.server.webserver.caddy = {
      enable = true;
      cloudflare.enable = true;
    };

    # Authelia portal virtual host
    services.caddy.virtualHosts = {
      "auth.${domain}".extraConfig = ''
        reverse_proxy localhost:9091
      '';
    };

    # Enable Redis for session storage
    services.redis.servers.authelia = {
      enable = true;
      port = 6379;
      bind = "127.0.0.1";
    };

    services.authelia.instances.main = {
      enable = true;

      secrets = {
        jwtSecretFile = secrets.authelia-jwt.path;
        storageEncryptionKeyFile = secrets.authelia-storage-key.path;
        sessionSecretFile = secrets.authelia-session.path;
      };

      settings = {
        theme = "dark";
        default_2fa_method = "totp";

        server = {
          address = "tcp://127.0.0.1:9091";
        };

        log = {
          level = "info";
        };

        authentication_backend = {
          file = {
            path = secrets.authelia-users.path;
          };
        };

        session = {
          domain = domain;
          redis = {
            host = "127.0.0.1";
            port = 6379;
          };
        };

        storage = {
          local = {
            path = "/var/lib/authelia-main/db.sqlite3";
          };
        };

        notifier = {
          filesystem = {
            filename = "/var/lib/authelia-main/notifications.txt";
          };
        };

        access_control = {
          default_policy = "deny";
          rules = [
            {
              domain = "auth.${domain}";
              policy = "bypass";
            }
          ];
        };
      };
    };
  };
}
