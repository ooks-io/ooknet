{
  lib,
  config,
  ...
}: let
  # my scuffed lib
  ook-lib = {
    math = import ./lib/math.nix {inherit lib;};
    container = import ./lib/containers.nix {inherit lib config;};
    services = import ./lib/services.nix {inherit lib;};
    color = let
      check = import ./lib/color/check.nix {inherit lib;};
      types = import ./lib/color/types.nix {
        inherit (ook-lib) math;
        inherit check;
      };
      translate = import ./lib/color/translate.nix {
        inherit lib;
        inherit (ook-lib) math;
        inherit types;
      };
      utils = import ./lib/color/utils.nix {
        inherit (ook-lib) math;
        inherit check types translate;
      };
    in {
      inherit check types translate utils;
    };
  };
  color = import ./color.nix {inherit ook-lib;};
in {
  # Expose color lib separately so hozen can use it without circular dependency
  _module.args.colorLib = ook-lib.color;

  _module.args.ook =
    {
      lib = ook-lib;
    }
    // color;
  flake.ook =
    {
      lib = ook-lib;
    }
    // color;
}
