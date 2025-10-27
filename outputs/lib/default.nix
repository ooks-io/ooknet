{
  lib,
  config,
  ...
}: let
  # my scuffed lib
  ook-lib = {
    math = import ./math.nix {inherit lib;};
    container = import ./containers.nix {inherit lib config;};
    services = import ./services.nix {inherit lib;};
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
        inherit check types translate;
      };
    in {
      inherit check types translate utils;
    };
  };
in {
  _module.args.ook.lib = ook-lib;
  flake.ook.lib = ook-lib;
}
