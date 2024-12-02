{
  config,
  lib,
  ook,
  ...
}: let
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) groups;
  inherit (config.ooknet.server.ookflix.services) jellyseer;
in {
  config = mkIf jellyseer.enable {
    # media requesting for jellyfin
    virtualisation.oci-containers.containers = {
      jellyseer = {
        image = "fallenbagel/jellyseerr:latest";
        autoStart = true;
        hostname = "jellyseer";
        ports = [(mkContainerPort jellyseer.port)];
        volumes = ["${jellyseer.stateDir}:/config"];
        extraOptions = ["--network" "host"];
        labels = mkContainerLabel {
          name = "jellyseer";
          inherit (jellyseer) domain port;
          homepage = {
            group = "media";
            description = "media-server requesting";
          };
        };
        environment = mkContainerEnvironment jellyseer.user.id groups.media.id;
      };
    };
  };
}
