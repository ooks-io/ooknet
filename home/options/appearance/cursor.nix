{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in
  
{
  options.ooknet.cursor = {
    enable = mkEnableOption "Enable cursor module";
    package = mkOption {
      type = types.package;
      default = null;
      description = "Package for cursor";
      example = "pkgs.bibata-cursors";
    };
    name = mkOption {
      type = types.str;
      default = "";
      description = "Name of cursor";
      example = "Bibata-Modern-Ice";
    };
    size = lib.mkOption {
      type = types.int;
      default = 22;
      description = "Size of cursor";
      example = "22";
    };
  };
}
