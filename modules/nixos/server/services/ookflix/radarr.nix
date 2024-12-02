{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ./lib.nix {inherit lib config self;};
  inherit (ookflixLib) mkServiceUser mkServiceStateDir;
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment;
  inherit (config.ooknet.server.ookflix) groups volumes;
  inherit (config.ooknet.server.ookflix.services) radarr;
in {
  config = mkIf radarr.enable {
    users = mkServiceUser radarr.user.name;
    systemd.tmpfiles = mkServiceStateDir "radarr" radarr.stateDir;
    virtualisation.oci-containers.containers = {
      radarr = {
        image = "ghcr.io/hotio/qbittorrent";
        autoStart = true;
        hostname = "radarr";
        ports = ["${radarr.port}:${radarr.port}"];
        volumes = [
          "${radarr.stateDir}:/config"
          "${volumes.data.root}:/data"
        ];
        extraOptions = ["--network" "host"];
        labels = mkContainerLabel {
          name = "radarr";
          inherit (radarr) port domain;
          homepage = {
            group = "arr";
            description = "media-server movies downloader";
          };
        };
        environment = mkContainerEnvironment radarr.user.id groups.media.id;
      };
    };
  };
}
