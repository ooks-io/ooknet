{ook, ...}: let
  style = {
    color = import ./dark.nix {inherit ook;};
    light.color = import ./light.nix {inherit ook;};
    dark.color = import ./dark.nix {inherit ook;};
  };
in {
  _module.args.sytle = style;
  flake.style = style;
}
