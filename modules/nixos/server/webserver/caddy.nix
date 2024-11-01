{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server.webserver) caddy;
in {
  config = mkIf caddy.enable {
    users.groups.www = {};
    services.caddy = {
      enable = true;
      group = "www";
    };
  };
}
