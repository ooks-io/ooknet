{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem getExe;

  inherit (config.ooknet.server) services domain;
  inherit (config.services) fail2ban;

  settingsFormat = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
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

          # rate limiting: 30 requests per minute per IP
          rate_limit {
            zone git {
              key {remote_host}
              events 30
              window 1m
            }
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

      fail2ban.jails.forgejo.settings = {
        filter = "forgejo";
        mode = "aggressive";
        action = "nftables-multiport";
        maxretry = 5;
        findTime = "24h";
        bantime = "48h";
      };
    };
    environment = {
      etc."fail2ban/filter.d/forgejo.conf".text = mkIf fail2ban.enable (settingsFormat {
        Definitions = {
          failregex = "^.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).";
          journalmatch = "_SYSTEMD_UNIT=forgejo.service";
        };
      });

      # credit to TLATER
      # https://discourse.nixos.org/t/how-to-access-forgejo-cli/45370
      systemPackages = let
        cfg = config.services.forgejo;
        forgejo-cli = pkgs.writeScriptBin "forgejo-cli" ''
          #!${pkgs.runtimeShell}
          cd ${cfg.stateDir}
          sudo=exec
          if [[ "$USER" != forgejo ]]; then
            sudo='exec /run/wrappers/bin/sudo -u ${cfg.user} -g ${cfg.group} --preserve-env=GITEA_WORK_DIR --preserve-env=GITEA_CUSTOM'
          fi
          # Note that these variable names will change
          export GITEA_WORK_DIR=${cfg.stateDir}
          export GITEA_CUSTOM=${cfg.customDir}
          $sudo ${getExe cfg.package} "$@"
        '';
      in [
        forgejo-cli
      ];
    };
  };
}
