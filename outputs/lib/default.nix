{
  lib,
  self,
  inputs,
  pkgs,
  ...
}: let
  # My person functions
  ook-lib = {
    builders = import ./builders.nix {inherit self lib inputs;};
    mkNeovim = import ./mkNeovim.nix {inherit inputs;};
  };
in {
  _module.args.ook.lib = ook-lib;
  flake.ook.lib = ook-lib;
}
