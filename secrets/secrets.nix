let
  keys = import ./keys.nix;
  inherit (keys) users workstations;
in

{
  "tailscale-auth.age".publicKeys = [ users.ooks] ++ workstations;
}
