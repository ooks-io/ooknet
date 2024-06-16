let
  sshKeys = import ../secrets/keys.nix;
in

{
  perSystem = { config, ... }: {
    imports = [
      {
        _module.args.keys = sshKeys;
      }
    ];
  };
  flake.keys = sshKeys;
}
