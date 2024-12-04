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
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) groups;
  inherit (config.ooknet.server.ookflix.services) jellyseerr;
in {
  config = mkIf jellyseerr.enable {
    # media requesting for jellyfin
    users = mkServiceUser jellyseerr.user.name;
    systemd.tmpfiles.settings.jellyseerrStateDir = mkServiceStateDir "jellyseerr";
    virtualisation.oci-containers.containers = {
      jellyseerr = {
        image = "ghcr.io/hotio/jellyseerr";
        autoStart = true;
        hostname = "jellyseerr";
        ports = [(mkContainerPort jellyseerr.port)];
        volumes = ["${jellyseerr.stateDir}:/config"];
        labels = mkContainerLabel {
          name = "jellyseerr";
          inherit (jellyseerr) domain port;
          homepage = {
            group = "media";
            description = "media-server requesting";
          };
        };
        environment = mkContainerEnvironment jellyseerr.user.id groups.media.id;
      };
    };
  };
}
