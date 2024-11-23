{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) storage users groups domain proxy;
in {
  config = mkIf media-server.sonarr.enable {
    services.sonarr = {
      enable = true;
      user = users.sonarr;
      group = groups.sonarr;
      dataDir = storage.state.sonarr;
    };
    ooknet.server.webserver.caddy.enable = true;
    services.caddy.virtualHosts."${domain.sonarr}".extraConfig = proxy.sonarr;
  };
}
