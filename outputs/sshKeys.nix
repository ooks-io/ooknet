let
  sshKeys = import ../secrets/keys.nix;
in {
  perSystem = {...}: {
    imports = [
      {
        _module.args.keys = sshKeys;
      }
    ];
  };
  flake.keys = sshKeys;
}
