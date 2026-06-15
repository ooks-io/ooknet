{
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str bool;
in {
  options.ooknet.server.forgejo = {
    # blanks the logo asset (custom/public/assets/img/logo.{svg,png}); the
    # supported way to customize forgejo branding, no app.ini flag exists
    hideLogo = mkOption {
      type = bool;
      default = false;
      description = "Replace the Forgejo logo with a blank asset.";
    };
    customTheme = {
      enable = mkEnableOption "ooknet-generated Forgejo color theme (from ook.themes.dark)";
      name = mkOption {
        type = str;
        default = "ooknet";
        description = "Theme name, served as theme-<name>.css and selectable in the UI.";
      };
      default = mkOption {
        type = bool;
        default = true;
        description = "Set this theme as the instance DEFAULT_THEME.";
      };
    };
  };
}
