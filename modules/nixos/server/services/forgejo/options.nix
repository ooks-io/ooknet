{
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str;
  mkColorOption = description:
    mkOption {
      type = str;
      default = "";
      inherit description;
    };
in {
  options.ooknet.server.forgejo.customTheme = {
    enable = mkEnableOption;
    light = {
      primary = mkColorOption;
    };
  };
}
