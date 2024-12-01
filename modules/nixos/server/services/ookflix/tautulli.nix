{
  config,
  lib,
  ook,
  ...
}: let
  ookflixLib = import ./lib.nix {inherit lib config;};
  inherit (ookflixLib) mkServiceUser mkServiceStateDir;
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) groups;
  inherit (config.ooknet.server.services) tautulli;
in {
  config = mkIf tautulli.enable {
    users = mkServiceUser tautulli.user.name;
    systemd.tmpfiles = mkServiceStateDir "tautulli" tautulli.stateDir;
    virtualisation.oci-containers.containers = {
      # plex monitoring service
      tautulli = {
        image = "lscr.io/linuxserver/tautulli:latest";
        autoStart = true;
        hostname = "tautulli";
        ports = [(mkContainerPort tautulli.port)];
        volumes = ["${tautulli.stateDir}:/config"];
        labels = mkContainerLabel {
          name = "tautulli";
          inherit (tautulli) port domain;
          homepage = {
            group = "monitoring";
            description = "media-server monitoring";
          };
        };
        environment = mkContainerEnvironment tautulli.user.id groups.media.id;
      };
    };
  };
}
