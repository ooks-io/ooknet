{
  config,
  lib,
  self',
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
        package = self'.packages.caddy-with-cloudflare;
        globalConfig = ''
          servers {
            trusted_proxies cloudflare {
            interval 12h
            timeout 15s
            }
          }
        '';
      })
    ];
  };
}
