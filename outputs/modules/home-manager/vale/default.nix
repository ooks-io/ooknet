{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) filterAttrs mapAttrs mkEnableOption mkOption mkIf;
  inherit (lib.generators) toINIWithGlobalSection;
  inherit (lib.types) attrsOf submodule listOf str enum package nullOr;

  filterNullRec = let
    # helper to check if a value should be kept
    isNonNull = value:
      if builtins.isAttrs value
      then filterNullRec value != {}
      else value != null;
  in
    attrs:
      filterAttrs
      (_: isNonNull)
      (mapAttrs (
          name: value:
            if builtins.isAttrs value
            then filterNullRec value
            else value
        )
        attrs);

  listToStr = list: builtins.concatStringsSep "," list;
  availableStyles = [
    "alex"
    "google"
    "joblint"
    "proselint"
    "write-good"
    "readability"
    "microsoft"
  ];
  formatOptions = submodule {
    freeformType = attrsOf str;
    options = {
      BasedOnStyles = mkOption {
        type = nullOr (listOf str);
        default = null;
        apply = listToStr;
      };
      BlockIgnores = mkOption {
        type = nullOr str;
        default = null;
      };
      TokenIgnores = mkOption {
        type = nullOr str;
        default = null;
      };
      CommentDelimiters = mkOption {
        type = nullOr str;
        default = null;
      };
      Transform = mkOption {
        type = nullOr str;
        default = null;
      };
    };
  };

  cfg = config.programs.vale;
in {
  options.programs.vale = {
    enable = mkEnableOption "Enable vale linter";
    package = mkOption {
      type = package;
      default = pkgs.vale;
    };
    styles = mkOption {
      type = listOf (enum availableStyles);
      default = [];
      description = "Style packages to include.";
    };
    globalSettings = {
      MinAlertLevel = mkOption {
        type = enum [
          "suggestion"
          "warning"
          "error"
        ];
        default = "suggestion";
        description = "Set the minimum alert level that Vale will report.";
      };
      IgnoredScopes = mkOption {
        type = nullOr (listOf str);
        default = null;
        description = "Specifies inline-level HTML tags to ignore.";
        apply = v:
          if v != null
          then listToStr
          else null;
      };
    };
    formatSettings = mkOption {
      type = nullOr (attrsOf formatOptions);
      default = null;
    };
  };
  config = mkIf cfg.enable {
    home.packages = [
      (cfg.package.withStyles (
        styles:
          map (name: styles.${name}) config.programs.vale.styles
      ))
    ];
    xdg.configFile."vale/.vale.ini".text = toINIWithGlobalSection {} {
      globalSection = filterNullRec cfg.globalSettings;
      sections =
        if cfg.formatSettings != null
        then filterNullRec cfg.formatSettings
        else {};
    };
  };
}
