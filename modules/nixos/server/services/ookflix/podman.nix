{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.ooknet.server) ookflix;
in {
  config = mkIf ookflix.enable {
    # add admin to podman group
    users.groups.podman.members = [admin.name];
    virtualisation = {
      # explicitly set this even though its the default value
      # this enables the module below
      oci-containers.backend = "podman";
      podman = {
        # periodically prunes podman resources
        # defaults to --all, weekly
        autoPrune.enable = true;

        # aliases docker command to podman
        dockerCompat = true;

        # makes the podman sockaet available in place of docker socket
        dockerSocket.enable = true;
        # settings for containers/networks/podman.json
        defaultNetwork.settings = {
          # allows udp port 53 on podmans network interface: podman+
          dns_enabled = true;
        };
      };
    };
  };
}
