{
  config,
  lib,
  pkgs,
  ook,
  ...
}: let
  inherit (lib) mkIf elem getExe optionalAttrs optionals;

  inherit (config.ooknet.server) services domain;
  inherit (config.services) fail2ban;

  forgejoCfg = config.ooknet.server.forgejo;
  themeCfg = forgejoCfg.customTheme;
  themeFile = pkgs.writeText "theme-${themeCfg.name}.css" (
    ook.lib.color.export.toForgejoTheme {scheme = ook.themes.dark;}
  );

  blankLogoSvg = pkgs.writeText "logo.svg" ''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"></svg>'';
  blankLogoPng = pkgs.runCommand "logo.png" {nativeBuildInputs = [pkgs.imagemagick];} ''
    magick -size 1x1 xc:transparent PNG32:$out
  '';

  settingsFormat = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
in {
  imports = [./options.nix];

  config = mkIf (elem "forgejo" services) {
    networking.firewall.allowedTCPPorts = [2222];

    systemd.tmpfiles.rules = let
      fj = config.services.forgejo;
      pub = "${fj.customDir}/public";
      mkdir = p: "d ${p} 0750 ${fj.user} ${fj.group} - -";
    in
      optionals (themeCfg.enable || forgejoCfg.hideLogo) [
        (mkdir pub)
        (mkdir "${pub}/assets")
      ]
      ++ optionals themeCfg.enable [
        (mkdir "${pub}/assets/css")
        "L+ ${pub}/assets/css/theme-${themeCfg.name}.css - - - - ${themeFile}"
      ]
      ++ optionals forgejoCfg.hideLogo [
        (mkdir "${pub}/assets/img")
        "L+ ${pub}/assets/img/logo.svg - - - - ${blankLogoSvg}"
        "L+ ${pub}/assets/img/logo.png - - - - ${blankLogoPng}"
      ];

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
          ui = mkIf themeCfg.enable ({
              THEMES = "forgejo-auto,forgejo-light,forgejo-dark,${themeCfg.name}";
            }
            // optionalAttrs themeCfg.default {
              DEFAULT_THEME = themeCfg.name;
            });
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
