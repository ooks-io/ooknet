{
  config,
  lib,
  ook,
  self,
  ...
}: let
  ookflixLib = import ./lib.nix {inherit self lib config;};
  inherit (ookflixLib) mkServiceUser;
  inherit (lib) mkIf;
  inherit (ook.lib.container) mkContainerEnvironment mkContainerPort mkServiceSecret;
  inherit (config.ooknet.server.ookflix.services) transmission gluetun;
in {
  config = mkIf gluetun.enable {
    users = mkServiceUser gluetun.user.name;
    age.secrets.vpn_env = mkServiceSecret "vpn_env" "gluetun";
    virtualisation.oci-containers.containers = {
      # vpn container
      gluetun = mkIf {
        image = "qmcgaw/gluetun:latest";
        # should make this an option.
        environmentFiles = [config.age.secrets.vpn_env.path];
        ports = [
          (mkContainerPort transmission.port)
        ];
        environment = mkContainerEnvironment gluetun.user.id gluetun.group.id {
          VPN_SERVICE_PROVIDER = gluetun.provider;
          VPN_TYPE = "wireguard";
        };
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
