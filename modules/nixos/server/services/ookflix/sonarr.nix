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
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) groups volumes;
  inherit (config.ooknet.server.ookflix.services) sonarr;
in {
  config = mkIf sonarr.enable {
    users = mkServiceUser sonarr.user.name;
    systemd.tmpfiles = mkServiceStateDir "sonarr" sonarr.stateDir;
    virtualisation.oci-containers.containers = {
      sonarr = {
        image = "ghcr.io/hotio/sonarr";
        autoStart = true;
        hostname = "sonarr";
        ports = [(mkContainerPort sonarr.port)];
        volumes = [
          "${sonarr.stateDir}:/config"
          "${volumes.data.root}:/data"
        ];
        labels = mkContainerLabel {
          name = "sonarr";
          inherit (sonarr) port domain;
          homepage = {
            group = "arr";
            description = "media-server tv downloader";
          };
        };
        environment =
          mkContainerEnvironment sonarr.user.id groups.media.id
          // {
            UMASK = "002";
          };
      };
    };
  };
}
