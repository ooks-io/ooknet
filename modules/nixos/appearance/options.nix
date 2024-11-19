{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str package path int;

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
