{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib) mkIf;

  inherit (config.ooknet) host;
  inherit (host) admin;
  inherit (config.services) tailscale transmission;
in {
  age.identityPaths = [
    "/home/${admin.name}/.ssh/id_ed25519"
  ];

  age.secrets = {
    tailscale-auth = mkIf tailscale.enable {
      file = "${self}/secrets/tailscale-auth.age";
      mode = "444";
    };
    github_key = mkIf admin.homeManager {
      file = "${self}/secrets/github_key.age";
      path = "/home/${admin.name}/.ssh/github_key";
      owner = "${admin.name}";
      group = "users";
    };
    ooknet_org = mkIf admin.homeManager {
      file = "${self}/secrets/ooknet_org.age";
      path = "/home/${admin.name}/.ssh/ooknet_org";
      owner = "${admin.name}";
      group = "users";
    };
    spotify_key = mkIf admin.homeManager {
      file = "${self}/secrets/spotify_key.age";
      owner = "${admin.name}";
      group = "users";
    };
    mullvad_wg = mkIf transmission.enable {
      file = "${self}/secrets/mullvad_wg.age";
    };
  };
}
