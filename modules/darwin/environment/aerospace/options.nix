{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption filterAttrs remove mkIf;
  inherit (lib.types) submodule str nullOr bool int listOf either;
  cfg = config.services.aerospace;

  conditionType = submodule {
    options = {
      id = mkOption {
        type = nullOr str;
        default = null;
        description = "Application id to match";
      };
      name = mkOption {
        type = nullOr str;
        default = null;
        description = "Application name to match";
      };
      duringStartup = mkOption {
        type = bool;
        default = false;
        description = "Apply rule only during startup";
      };
      title = mkOption {
        type = nullOr str;
        default = null;
        description = "Window title to match (supports regex)";
      };
    };
  };

  windowRuleType = submodule {
    options = {
      conditions = mkOption {
        type = conditionType;
        description = "Conditions for matching window";
      };
      float = mkOption {
        type = bool;
        default = false;
        description = "Set the window to floating";
      };
      workspace = mkOption {
        type = nullOr (either int str);
        default = null;
        description = "Workspace to move the window to (can be a number or name like 'Browser1')";
      };
      checkFurtherCallbacks = mkOption {
        type = bool;
        default = false;
        description = "Override callback behaviour";
      };
    };
  };

  constructRule = rule: {
    "if" = filterAttrs (_: v: v != null) {
      inherit (rule.conditions) title name;
      app-id = rule.conditions.id;
      during-aerospace-startup =
        if rule.conditions.duringStartup
        then true
        else null;
    };
    "check-further-callbacks" = rule.checkFurtherCallbacks;
    run = remove null [
      (
        if rule.float
        then "layout floating"
        else null
      )
      (
        if rule.workspace != null
        then "move-node-to-workspace ${toString rule.workspace}"
        else null
      )
    ];
  };
in {
  options.services.aerospace = {
    window-rules = mkOption {
      type = listOf windowRuleType;
      default = [];
      description = "Window rules for aerospace";
    };
  };

  config = mkIf cfg.enable {
    services.aerospace.settings = {
      on-window-detected = map constructRule cfg.window-rules;
    };
  };
}
