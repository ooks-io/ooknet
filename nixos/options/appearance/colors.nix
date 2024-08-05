{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) str enum attrsOf;

  cfg = config.ooknet.colorscheme;
in {
  # simple colorscheme module bases on misterio77/nix-colors
  options.ooknet.colorscheme = {
    name = mkOption {
      type = enum ["hozen"];
      default = "hozen";
    };
    variant = mkOption {
      type = enum ["dark" "light"];
      default = "dark";
    };
    slug = mkOption {
      type = str;
      default = "${toString cfg.name-cfg.variant}";
    };
    palette = {
      type = attrsOf str;
      default = (import ./palettes/${cfg.slug}.nix).colorscheme.palette;
    };
  };
}
