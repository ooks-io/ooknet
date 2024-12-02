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
  inherit (config.ooknet.server.ookflix.services) transmission gluetun;
in {
  config = mkIf transmission.enable {
    users = mkServiceUser transmission.user.name;
    systemd.tmpfiles = mkServiceStateDir "transmission" transmission.stateDir;
    virtualisation.oci-containers.containers = {
      # Torrent client
      transmission = {
        image = "lscr.io/linuxserver/transmission:latest";
        environmentFiles = [config.age.secrets.transmission_env.path];
        environment = mkContainerEnvironment transmission.user.id groups.downloads.id;
        dependsOn = ["gluetun"];
        networkMode = "service:gluetun"; # Use VPN container's network
        volumes = [
          "${transmission.stateDir}:/config"
          "${volumes.downloads.root}:/downloads"
          "${volumes.downloads.watch}:/watch"
        ];
        extraOptions = ["--network=container:gluetun"];
        labels = mkContainerLabel {
          name = "transmission";
          inherit (transmission) port domain;
          homepage = {
            group = "downloads";
            description = "torrent client";
          };
        };
      };
    };
  };
}
