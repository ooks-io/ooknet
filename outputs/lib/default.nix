{
  lib,
  self,
  inputs,
  ...
}: let
  builders = import ./builders.nix {inherit self lib inputs;};
in {
  _module.args.ooknet.lib = {
    inherit builders;
  };
}
