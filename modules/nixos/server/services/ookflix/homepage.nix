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
  inherit (config.ooknet.server.ookflix.services) homepage;
in {
  config = mkIf homepage.enable {
    # media requesting for jellyfin
    users = mkServiceUser homepage.user.name;
    systemd.tmpfiles.settings.homepageStateDir = mkServiceStateDir "homepage";
    virtualisation.oci-containers.containers = {
      homepage = {
        image = "ghcr.io/benphelps/homepage:latest";
        autoStart = true;
        hostname = "homepage";
        ports = [(mkContainerPort homepage.port)];
        volumes = ["${homepage.stateDir}:/config"];
        labels = mkContainerLabel {
          name = "homepage";
          inherit (homepage) domain port;
        };
        environment = mkContainerEnvironment homepage.user.id groups.media.id;
      };
    };
  };
}
