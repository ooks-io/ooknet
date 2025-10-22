{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server.webserver) caddy;
  inherit (config.services) fail2ban;
in {
  config = mkIf (caddy.enable && fail2ban.enable) {
    services.fail2ban.jails.caddy-4xx = {
      settings = {
        maxretry = 20;
        findtime = "5m";
        bantime = "1h";
      };

      filter.Definition = {
        failregex = ''^.*"status":(4\d{2}).*"remote_ip":"<HOST>".*$'';
        journalmatch = "_SYSTEMD_UNIT=caddy.service";
      };
    };
  };
}
