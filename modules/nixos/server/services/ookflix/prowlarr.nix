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
  inherit (config.ooknet.server.ookflix) groups;
  inherit (config.ooknet.server.ookflix.services) prowlarr;
in {
  config = mkIf prowlarr.enable {
    users = mkServiceUser prowlarr.user.name;
    systemd.tmpfiles = mkServiceStateDir "prowlarr" prowlarr.stateDir;
    virtualisation.oci-containers.containers = {
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;
        hostname = "prowlarr";
        ports = [(mkContainerPort prowlarr.port)];
        volumes = ["${prowlarr.stateDir}:/config"];
        labels = mkContainerLabel {
          name = "prowlarr";
          inherit (prowlarr) port domain;
          homepage = {
            group = "arr";
            description = "media-server indexer";
          };
        };
        environment =
          mkContainerEnvironment prowlarr.user.id groups.media.id
          // {
            UMASK = "002";
          };
      };
    };
  };
}
