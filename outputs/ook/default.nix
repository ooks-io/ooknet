{
  lib,
  config,
  inputs,
  ...
}: let
  style = inputs.style;

  # style nests scales under colors and semantic under colors.semantic, the
  # tree reads the flat shape (color.layout.body, color.red.base, color.base05)
  flatten = t:
    t.colors
    // t.colors.semantic
    // t.colors.base24
    // {
      inherit (t) slug;
      typography =
        t.colors.semantic.typography
        // {
          # old name, keep until consumers move
          contrast-text = t.colors.semantic.typography.text-inverse;
        };
    };

  themes = lib.mapAttrs (_: flatten) style.theme;

  # my scuffed lib
  ook-lib = {
    inherit (style.lib') math;
    container = import ./lib/containers.nix {inherit lib config;};
    services = import ./lib/services.nix {inherit lib;};
    color =
      style.lib'.color
      // {
        inherit (style.lib') generators;
        export = import ./lib/color/export.nix {inherit lib;};
      };
  };

  ook = {
    lib = ook-lib;
    inherit themes;
    color = themes.dark;
  };
in {
  # Expose color lib separately so hozen can use it without circular dependency
  _module.args.colorLib = ook-lib.color;
  _module.args.ook = ook;
  flake.ook = ook;
}
