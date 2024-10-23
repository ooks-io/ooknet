let
  keys = import ../secrets/keys.nix;
in {
  perSystem._module.args.keys = keys;
  flake.keys = keys;
}
