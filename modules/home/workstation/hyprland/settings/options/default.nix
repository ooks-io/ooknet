{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    flatten
    attrValues
    concatStringsSep
    filterAttrs
    mapAttrsToList
    boolToString
    mkOption
    isBool
    ;
  inherit
    (lib.types)
    listOf
    attrsOf
    submodule
    nullOr
    str
    int
    bool
    oneOf
    ;

  # our cursed regex types
  hyprland = import ./rules.nix {inherit lib;};

  _toString = type: val:
    if isBool val
    then
      if type == "windowrule"
      then
        if val
        then "1"
        else "0"
      else boolToString val # for workspace rules
    else toString val;

  # format rules for hyprland
  formatRules = type: rule:
    concatStringsSep "," (
      mapAttrsToList (name: value: "${name}:${_toString type value}")
      (filterAttrs (_: v: v != null) rule)
    );

  # workspace handling
  mkWorkspaces = mapAttrsToList (
    selector: rules: "${selector},${formatRules "workspacerule" rules}"
  );

  # rule options
  mkRuleOption = type: description:
    mkOption {
      type = nullOr type;
      default = null;
      inherit description;
    };

  # window rule matchers
  windowRuleMatchers = submodule {
    options = {
      class = mkRuleOption str "Window class matcher";
      title = mkRuleOption str "Window title matcher";
      initialClass = mkRuleOption str "Initial window class matcher";
      initialTitle = mkRuleOption str "Initial window title matcher";
      tag = mkRuleOption str "Window tag matcher";
      xwayland = mkRuleOption bool "Match XWayland windows";
      floating = mkRuleOption bool "Match floating windows";
      fullscreen = mkRuleOption bool "Match fullscreen windows";
      workspace = mkRuleOption str "Match windows on specific workspace";
    };
  };

  # Workspace rules submodule
  workspaceRules = submodule {
    options = {
      name = mkRuleOption str "Default name of workspace";
      monitor = mkRuleOption str "Binds workspace to monitor";
      default = mkRuleOption bool "Set as default workspace for monitor";
      gapsin = mkRuleOption int "Gaps between windows";
      gapsout = mkRuleOption int "Gaps between windows and monitor edges";
      bordersize = mkRuleOption int "Border size around windows";
      border = mkRuleOption bool "Draw borders";
      shadow = mkRuleOption bool "Draw shadows";
      rounding = mkRuleOption bool "Draw rounded corners";
      decorate = mkRuleOption bool "Draw window decorations";
      persistent = mkRuleOption bool "Keep workspace alive when empty";
      on-created-empty = mkRuleOption str "Command to run when workspace created empty";
    };
  };

  # Window rules type using our validated types from rules.nix
  windowRuleType = listOf (oneOf (attrValues hyprland.types));

  cfg = config.wayland.windowManager.hyprland;
in {
  options.wayland.windowManager.hyprland = {
    # Workspace configuration
    workspaces = mkOption {
      type = attrsOf workspaceRules;
      default = {};
      description = "Workspace-specific configurations";
    };

    # Window rules configuration
    windowRules = mkOption {
      type = listOf (submodule {
        options = {
          matches = mkOption {
            type = windowRuleMatchers;
            description = "Window matching criteria";
          };
          rules = mkOption {
            type = windowRuleType;
            description = "Rules to apply to matching windows";
          };
        };
      });
      default = [];
      description = "Window-specific rules";
    };
  };

  config.wayland.windowManager.hyprland.settings = {
    workspace = mkWorkspaces cfg.workspaces;
    windowrulev2 = let
      # Convert rules to Hyprland format
      formatWindowRule = rule: let
        matches = formatRules "windowrule" rule.matches;
        rules = map (r: "${r},${matches}") rule.rules;
      in
        rules;
    in
      flatten (map formatWindowRule cfg.windowRules);
  };
}
