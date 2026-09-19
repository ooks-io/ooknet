{
  lib,
  config,
  ...
}: let
  inherit (lib) filterAttrs mapAttrsToList mkOption optionalAttrs;
  inherit (lib.types) listOf attrsOf submodule nullOr str int bool oneOf;

  mkRuleOption = type: description:
    mkOption {
      type = nullOr type;
      default = null;
      inherit description;
    };

  notNull = filterAttrs (_: v: v != null);

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
      default_name = mkRuleOption str "Default name of workspace";
      monitor = mkRuleOption str "Binds workspace to monitor";
      default = mkRuleOption bool "Set as default workspace for monitor";
      gaps_in = mkRuleOption int "Gaps between windows";
      gaps_out = mkRuleOption int "Gaps between windows and monitor edges";
      border_size = mkRuleOption int "Border size around windows";
      no_border = mkRuleOption bool "Disable borders";
      no_shadow = mkRuleOption bool "Disable shadows";
      no_rounding = mkRuleOption bool "Disable rounded corners";
      decorate = mkRuleOption bool "Draw window decorations";
      persistent = mkRuleOption bool "Keep workspace alive when empty";
      animation = mkRuleOption str "Workspace animation style";
      layout = mkRuleOption str "Layout for this workspace";
      on_created_empty = mkRuleOption str "Command to run when workspace created empty";
    };
  };

  # window rule effects are lua table keys, see
  # https://wiki.hypr.land/configuring/core/rules/window-rules/
  ruleValue = oneOf [bool int str (listOf int)];

  cfg = config.wayland.windowManager.hyprland;
in {
  options.wayland.windowManager.hyprland = {
    workspaces = mkOption {
      type = attrsOf workspaceRules;
      default = {};
      description = "Workspace rules keyed by workspace selector";
    };

    windowRules = mkOption {
      type = listOf (submodule {
        options = {
          name = mkRuleOption str "Rule name, named rules return a handle in lua";
          matches = mkOption {
            type = windowRuleMatchers;
            description = "Window matching criteria";
          };
          rules = mkOption {
            type = attrsOf ruleValue;
            description = "Effects to apply to matching windows";
          };
        };
      });
      default = [];
      description = "Window rules";
    };
  };

  config.wayland.windowManager.hyprland.settings = {
    workspace_rule =
      mapAttrsToList (workspace: rules: {inherit workspace;} // notNull rules)
      cfg.workspaces;

    window_rule =
      map (
        r:
          {match = notNull r.matches;}
          // optionalAttrs (r.name != null) {inherit (r) name;}
          // r.rules
      )
      cfg.windowRules;
  };
}
