{
  lib,
  self,
  inputs,
  ...
}: let
  # my scuffed lib
  ook-lib = {
    builders = import ./builders.nix {inherit self lib inputs;};
    mkNeovim = import ./mkNeovim.nix {inherit inputs;};
    math = import ./math.nix {inherit lib;};
    color = let
      check = import ./color/check.nix {inherit lib;};
      types = import ./color/types.nix {
        inherit (ook-lib) math;
        inherit check;
      };
      translate = import ./color/translate.nix {
        inherit lib;
        inherit (ook-lib) math;
        inherit types;
      };
      utils = import ./color/utils.nix {
        inherit (ook-lib) math;
        inherit types translate;
      };
    in {
      inherit check types translate;
      inherit (utils) lighten darken saturate desaturate mkColorScale;
    };
  };
in {
  _module.args.ook.lib = ook-lib;
  flake.ook.lib = ook-lib;
}
