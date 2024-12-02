{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) storage users groups domain proxy;
in {
  config = mkIf media-server.radarr.enable {
    services.radarr = {
      enable = true;
      user = users.radarr;
      group = groups.media;
      dataDir = storage.state.radarr;
      openFirewall = true;
    };
    ooknet.server.webserver.caddy.enable = true;
    services.caddy.virtualHosts."${domain.radarr}".extraConfig = proxy.radarr;
  };
}
