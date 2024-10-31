{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet.server) services domain;
  inherit (lib) mkIf elem;
in {
  config = mkIf (elem "forgejo" services) {
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
          };
        };
      };
      caddy.virtualHosts = {
        "git.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:3000
        '';
      };
    };
  };
}
