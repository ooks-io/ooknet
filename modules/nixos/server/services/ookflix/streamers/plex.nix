{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ../lib.nix {inherit lib config self;};
  inherit (ookflixLib) mkServiceUser mkServiceStateDir;
  inherit (lib) mkIf optionalAttrs;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) gpuAcceleration volumes groups;
  inherit (config.ooknet.server.ookflix.services) plex;
in {
  config = mkIf plex.enable {
    # not sure if this is needed for podman
    hardware.nvidia-container-toolkit.enable = gpuAcceleration.enable && gpuAcceleration.type == "nvidia";

    # users/group/directories configuration, see lib.nix
    users = mkServiceUser plex.user.name;
    systemd.tmpfiles.settings.plexStateDir = mkServiceStateDir "plex";

    # container configuration
    virtualisation.oci-containers.containers = {
      # media streaming server
      plex = {
        image = "lscr.io/linuxserver/plex:latest";
        autoStart = true;
        hostname = "plex";
        ports = [(mkContainerPort plex.port)];
        volumes = [
          "${volumes.media.root}:/data"
          "${plex.stateDir}:/config"
        ];
        labels = mkContainerLabel {
          name = "plex";
          inherit (plex) domain port;
          homepage = {
            group = "media";
            description = "media-server streamer";
          };
        };
        environment =
          mkContainerEnvironment plex.user.id groups.media.id
          // optionalAttrs (gpuAcceleration.enable && gpuAcceleration.type == "nvidia") {
            NVIDIA_VISIBLE_DEVICES = "all";
          };
      };
    };
  };
}
