{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) groups users storage domain proxy;
in {
  config = mkIf media-server.plex.enable {
    services.plex = {
      enable = true;
      user = users.streamer;
      group = groups.media;
      dataDir = storage.state.plex;
    };
    ooknet.server.webserver.caddy.enable = true;
    services.caddy.virtualHosts."${domain.plex}".extraConfig = proxy.plex;
  };
}
