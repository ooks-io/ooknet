{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) storage groups users domain proxy;
in {
  config = mkIf media-server.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      user = users.jellyfin;
      group = groups.media;
      dataDir = storage.state.jellyfin;
      openFirewall = true;
    };
    ooknet.server.webserver.caddy.enable = true;
    services.caddy.virtualHosts."${domain.jellyfin}".extraConfig = proxy.jellyfin;
  };
}
