let
  keys = import ./keys.nix;
  inherit (keys) users workstations servers;
in {
  "tailscale-auth.age".publicKeys = [users.ooks] ++ workstations;
  "github_key.age".publicKeys = [users.ooks] ++ workstations;
  "spotify_key.age".publicKeys = [users.ooks] ++ workstations;
  "ooknet_org.age".publicKeys = [users.ooks] ++ workstations;
  "mullvad_wg.age".publicKeys = [users.ooks] ++ workstations ++ servers;
  "containers/vpn_env.age".publicKeys = [users.ooks] ++ workstations ++ servers;
}
