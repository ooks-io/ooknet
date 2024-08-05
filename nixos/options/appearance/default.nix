{
  config,
  lib,
  ...
}: let
  inherit (lib) isString hasPrefix removePrefix mkOption mkOptionType;
  inherit (lib.types) enum str nullOr package path int attrsOf coercedTo;
  hexColorType = mkOptionType {
    name = "hex-color";
    descriptionClass = "noun";
    description = "RGB color in hex format";
    check = x: isString x && !(hasPrefix "#" x);
  };

  mkFontOption = {
    family = mkOption {
      type = str;
      default = "";
    };
    package = mkOption {
      type = package;
      default = null;
    };
  };

  cfg = config.ooknet.appearance;
in {
  imports = [./palettes];
  options.ooknet.appearance = {
    theme = mkOption {
      type = nullOr (enum ["minimal" "phone"]);
      default = null;
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
    colorscheme = {
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
        default = "${toString cfg.colorscheme.name}-${toString cfg.colorscheme.variant}";
      };
      palette = mkOption {
        type = attrsOf (coercedTo str (removePrefix "#") hexColorType);
        default = {};
      };
    };
  };
}
