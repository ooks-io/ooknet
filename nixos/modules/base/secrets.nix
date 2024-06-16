{ config, lib, self, ... }:

let
  inherit (lib) mkIf;

  host = config.ooknet.host;
  admin = host.admin;
  tailscale = host.networking.tailscale;
in

{
  age.identityPaths = [
    "/home/${admin.name}/.ssh/id_ed25519"
  ];

  age.secrets = {
    tailscale-auth = mkIf tailscale.enable {
      file = "${self}/secrets/tailscale-auth.age";
      owner = "${admin.name}";
      group = "users";
      mode = "400";
    };
  };
}
