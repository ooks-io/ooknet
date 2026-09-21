{
  lib,
  config,
  ook,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) str package path int bool submodule nullOr enum attrs;

  mkVariantOption = {
    regular = mkOption {
      type = str;
      default = "";
    };
    bold = mkOption {
      type = str;
      default = "";
    };
    italic = mkOption {
      type = str;
      default = "";
    };
    boldItalic = mkOption {
      type = str;
      default = "";
    };
  };

  mkBaseFontOption = {
    family = mkOption {
      type = str;
      default = "";
    };
    variants = mkVariantOption;
    package = mkOption {
      type = package;
      default = null;
    };
    size = mkOption {
      type = int;
      default = 18;
    };
    bitmap = mkOption {
      type = bool;
      default = false;
    };
  };
  mkFontOption =
    mkBaseFontOption
    // {
      fallback = mkOption {
        type = nullOr (submodule {options = mkBaseFontOption;});
        default = null;
      };
    };
in {
  #  imports = [./palettes];
  options.ooknet.appearance = {
    scheme = mkOption {
      type = enum ["dark" "light"];
      default = "dark";
    };
    # the palette for the active scheme, read this instead of ook.color so the
    # scheme can differ per host
    colors = mkOption {
      type = attrs;
      readOnly = true;
      default = ook.themes.${config.ooknet.appearance.scheme};
    };
    fonts = {
      monospace = mkFontOption;
      regular = mkFontOption;
    };
    wallpaper = {
      path = mkOption {
        type = path;
        default = null;
      };
    };
    cursor = {
      package = mkOption {
        type = package;
        default = null;
      };
      name = mkOption {
        type = str;
        default = "";
      };
      size = mkOption {
        type = int;
        default = 22;
      };
    };
  };
}
