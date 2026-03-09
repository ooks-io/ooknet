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

  hyprland = import ./rules.nix {inherit lib;};

  _toString = type: val:
    if isBool val
    then
      if type == "windowrule"
      then
        if val
        then "1"
        else "0"
      else boolToString val
    else toString val;

  # format match props for window rules: match:name value
  formatWindowMatches = rule:
    concatStringsSep ", " (
      mapAttrsToList (name: value: "match:${name} ${_toString "windowrule" value}")
      (filterAttrs (_: v: v != null) rule)
    );

  # format props for workspace rules: name:value
  formatWorkspaceRules = rule:
    concatStringsSep "," (
      mapAttrsToList (name: value: "${name}:${_toString "workspacerule" value}")
      (filterAttrs (_: v: v != null) rule)
    );

  mkWorkspaces = mapAttrsToList (
    selector: rules: "${selector},${formatWorkspaceRules rules}"
  );

  mkRuleOption = type: description:
    mkOption {
      type = nullOr type;
      default = null;
      inherit description;
    };

  windowRuleMatchers = submodule {
    options = {
      class = mkRuleOption str "Window class matcher";
      title = mkRuleOption str "Window title matcher";
      initial_class = mkRuleOption str "Initial window class matcher";
      initial_title = mkRuleOption str "Initial window title matcher";
      tag = mkRuleOption str "Window tag matcher";
      xwayland = mkRuleOption bool "Match XWayland windows";
      float = mkRuleOption bool "Match floating windows";
      fullscreen = mkRuleOption bool "Match fullscreen windows";
      workspace = mkRuleOption str "Match windows on specific workspace";
      pin = mkRuleOption bool "Match pinned windows";
      focus = mkRuleOption bool "Match focused windows";
      group = mkRuleOption bool "Match grouped windows";
      modal = mkRuleOption bool "Match modal windows";
      fullscreen_state_client = mkRuleOption int "Match fullscreen state client";
      fullscreen_state_internal = mkRuleOption int "Match fullscreen state internal";
      content = mkRuleOption str "Match content type";
      xdg_tag = mkRuleOption str "Match XDG tag";
    };
  };

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

  windowRuleType = listOf (oneOf (attrValues hyprland.types));

  cfg = config.wayland.windowManager.hyprland;
in {
  options.wayland.windowManager.hyprland = {
    workspaces = mkOption {
      type = attrsOf workspaceRules;
      default = {};
      description = "Workspace-specific configurations";
    };

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
    windowrule = let
      formatWindowRule = rule: let
        matches = formatWindowMatches rule.matches;
        rules = map (r: "${r}, ${matches}") rule.rules;
      in
        rules;
    in
      flatten (map formatWindowRule cfg.windowRules);
  };
}
