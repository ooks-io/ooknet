let
  sshKeys = import ../secrets/keys.nix;
in {
  perSystem = _: {_module.args.keys = sshKeys;};
  flake.keys = sshKeys;
}
