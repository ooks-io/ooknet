{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ../lib.nix {inherit self lib config;};
  inherit (ookflixLib) mkServiceUser;
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerEnvironment;
  inherit (config.ooknet.server.ookflix.services) qbittorrent gluetun;
in {
  config = mkIf gluetun.enable {
    users = mkServiceUser gluetun.user.name;
    virtualisation.oci-containers.containers = {
      # vpn container
      gluetun = mkIf gluetun.enable {
        image = "qmcgaw/gluetun:latest";
        # should make this an option.
        environmentFiles = [config.age.secrets.vpn_env.path];
        ports = [
          "${toString qbittorrent.exposedPort}:${toString qbittorrent.port}"
        ];
        environment = mkContainerEnvironment gluetun.user.id gluetun.group.id;
        extraOptions = [
          # give network admin permissions
          "--cap-add=NET_ADMIN"
          # pass the network tunnel device
          "--device=/dev/net/tun"
        ];
      };
    };
  };
}
