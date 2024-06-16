let
  keys = import ./keys.nix;
  inherit (keys) users workstations;
in

{
  "tailscale.age".publicKeys = [ users.ooks] ++ workstations;
}
