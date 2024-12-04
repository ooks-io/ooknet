{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ../lib.nix {inherit lib config self;};
  inherit (ookflixLib) mkServiceUser mkServiceStateDir;
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment;
  inherit (config.ooknet.server.ookflix) groups volumes;
  inherit (config.ooknet.server.ookflix.services) qbittorrent;
in {
  config = mkIf qbittorrent.enable {
    users = mkServiceUser qbittorrent.user.name;
    systemd.tmpfiles.settings.qbittorrentStateDir = mkServiceStateDir "qbittorrent";
    virtualisation.oci-containers.containers = {
      # Torrent client
      qbittorrent = {
        hostname = "qbittorrent";
        image = "ghcr.io/hotio/qbittorrent";
        dependsOn = ["gluetun"];
        volumes = [
          "${qbittorrent.stateDir}:/config"
          "${volumes.torrents.root}:/data/torrents"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
        labels = mkContainerLabel {
          name = "qbittorrent";
          inherit (qbittorrent) port domain;
          homepage = {
            group = "downloads";
            description = "torrent client";
          };
        };
        environment =
          mkContainerEnvironment qbittorrent.user.id groups.media.id
          // {
            UMASK = "002";
            WEBUI_PORTS = "${toString qbittorrent.port}/tcp,${toString qbittorrent.port}/udp";
            TORRENTING_PORT = "${toString qbittorrent.torrentPort}";
          };
      };
    };
  };
}
