{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str package path int bool submodule nullOr;

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
