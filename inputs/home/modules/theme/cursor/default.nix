{ lib, config, ... }: 
let
  cfg = config.homeModules.theme.cursor;
in

{
  options.homeModules.theme.cursor = {
    enable = lib.mkEnableOption "Enable cursor module";
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for cursor";
      example = "pkgs.bibata-cursors";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Name of cursor";
      example = "Bibata-Modern-Ice";
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "Size of cursor";
      example = "22";
    };
  };
  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      package = cfg.package;
      name = cfg.name;
      size = cfg.size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}

