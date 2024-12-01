{
  config,
  lib,
  ook,
  ...
}: let
  ookflixLib = import ./lib.nix {inherit lib config;};
  inherit (ookflixLib) mkServiceUser mkServiceStateDir;
  inherit (lib) mkIf optionalAttrs;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) gpuAcceleration services volumes groups;
  inherit (config.ooknet.server.ookflix.services) plex;
in {
  config = mkIf plex.enable {
    # not sure if this is needed for podman
    hardware.nvidia-container-toolkit.enable = gpuAcceleration.enable && gpuAcceleration.type == "nvidia";

    # users/group/directories configuration, see lib.nix
    users = mkServiceUser plex.user.name;
    systemd.tmpfiles = mkServiceStateDir "plex" plex.stateDir;

    # container configuration
    virtualisation.oci-containers.containers = {
      # media streaming server
      plex = {
        image = "lscr.io/linuxserver/plex:latest";
        autoStart = true;
        hostname = "plex";
        ports = [(mkContainerPort plex.port)];
        volumes = [
          "${volumes.media.movies}:/data/movies"
          "${volumes.media.tv}:/data/tv"
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
        extraOptions = optionalAttrs gpuAcceleration.enable (
          if gpuAcceleration.type == "nvidia"
          then [
            "--runtime=nvidia"
          ]
          else if gpuAcceleration.type == "intel"
          then [
            "--device=/dev/dri:/dev/dri"
          ]
          else if gpuAcceleration.type == "amd"
          then [
            "--device=/dev/dri:/dev/dri"
          ]
          else []
        );
        environment =
          mkContainerEnvironment plex.user.id groups.media.id
          // optionalAttrs (gpuAcceleration.enable && gpuAcceleration.type == "nvidia") {
            NVIDIA_VISIBLE_DEVICES = "all";
          };
      };
    };
  };
}
