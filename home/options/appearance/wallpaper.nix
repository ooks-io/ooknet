{ lib, ... }:

let
  inherit (lib) types mkEnableOption mkOption;
in

{
  options.ooknet.wallpaper = {
    enable = mkEnableOption "";
    path = mkOption {
      type = types.path;
      default = null;
      description = "Wallpaper Path";
    };
  };
}
