{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ../lib.nix {inherit lib config self;};
  inherit (ookflixLib) mkServiceStateDir mkServiceUser;
  inherit (lib) mkIf optionalAttrs;
  inherit (ook.lib.container) mkContainerLabel mkContainerEnvironment mkContainerPort;
  inherit (config.ooknet.server.ookflix) volumes services groups gpuAcceleration;
  inherit (config.ooknet.server.ookflix.services) jellyfin;
in {
  config = mkIf services.jellyfin.enable {
    hardware.nvidia-container-toolkit.enable = gpuAcceleration.enable && gpuAcceleration.type == "nvidia";
    users = mkServiceUser jellyfin.user.name;
    systemd.tmpfiles.settings.jellyfinStateDir = mkServiceStateDir "jellyfin";
    virtualisation.oci-containers.containers = {
      # media streaming server
      # docs: <https://docs.linuxserver.io/images/docker-jellyfin/>
      jellyfin = {
        image = "lscr.io/linuxserver/jellyfin:10.10.7";
        autoStart = true;
        hostname = "jellyfin";
        ports = [(mkContainerPort jellyfin.port)];
        volumes = [
          "${volumes.media.root}:/data"
          "${jellyfin.stateDir}:/config"
        ];
        labels = mkContainerLabel {
          name = "jellyfin";
          inherit (jellyfin) port domain;
          homepage = {
            group = "media";
            description = "media-server streamer";
          };
        };
        extraOptions =
          if gpuAcceleration.enable
          then [
            "--gpus=all"
          ]
          else [];
        environment =
          mkContainerEnvironment jellyfin.user.id groups.media.id
          // {JELLYFIN_PublishedServerUrl = jellyfin.domain;}
          // optionalAttrs (gpuAcceleration.enable && gpuAcceleration.type == "nvidia") {
            NVIDIA_VISIBLE_DEVICES = "all";
            NVIDIA_DRIVER_CAPABILITIES = "all";
          };
      };
    };
  };
}
