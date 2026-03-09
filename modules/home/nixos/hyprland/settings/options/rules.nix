{lib, ...}: let
  inherit (lib) concatStringsSep attrValues;
  inherit (lib.types) strMatching;

  # helper function for constructing regex patterns for hyprland rules
  mkRegexTarget = {
    name,
    regex ? [],
    extraRegex ? "",
    optional ? false,
  }: let
    regexPart = concatStringsSep "|" regex;
    parameterPart =
      if optional
      then "( (${regexPart}))?"
      else " (${regexPart})";
  in
    strMatching "${name}${parameterPart}${extraRegex}";

  toggleableRules = [
    "float"
    "tile"
    "fullscreen"
    "maximize"
    "pseudo"
    "no_initial_focus"
    "pin"
    "decorate"
    "no_blur"
    "no_anim"
    "no_dim"
    "opaque"
    "force_rgbx"
    "xray"
    "immediate"
    "dim_around"
    "focus_on_activate"
    "no_focus"
    "stay_focused"
    "keep_aspect_ratio"
    "nearest_neighbor"
    "no_max_size"
    "no_shortcuts_inhibit"
    "allows_input"
    "render_unfocused"
    "sync_fullscreen"
    "no_shadow"
    "center"
    "persistent_size"
    "no_follow_mouse"
    "no_screen_share"
    "no_vrr"
  ];

  patterns = {
    onOpt = "1|true|on|yes|0|false|off|no|toggle|unset";

    float = "[+-]?([0-9]*[.])?[0-9]+";
    int = "[0-9]+";
    alpha = ''(0|0?\.[[:digit:]]+|1|1\.0)'';
    percentage = "[0-9]+(%)?";

    anchor = "100%-w?-[0-9]+";
    coordinate = "${patterns.percentage}|${patterns.anchor}";
    deg = "(0-360)";

    numericId = "[1-9][0-9]*";
    sign = "[+-]";
    relative = "${patterns.sign}${patterns.numericId}";
    monitorPrefix = "(m|r)";
    monitorRelative = "${patterns.monitorPrefix}(${patterns.sign}${patterns.numericId}|~${patterns.numericId})";
    emptyModifiers = "[mn]*";
    empty = "empty${patterns.emptyModifiers}";
    mode = "(always|focus|fullscreen|none)";
    ident = "[A-Za-z0-9_][A-Za-z0-9_ -]*";
    name = "name:${patterns.ident}";
    special = "special(:[a-zA-Z0-9_-]+)?";
    previous = "previous(_per_monitor)?";
    openWorkspace = "e(${patterns.sign}${patterns.numericId}|~${patterns.numericId})";

    rgbValue = ''([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'';
    rgbaHex = ''rgba\([[:xdigit:]]{8}\)'';
    rgbaDecimal = ''rgba\(${patterns.rgbValue}, *${patterns.rgbValue}, *${patterns.rgbValue}, *${patterns.alpha}\)'';
    rgbHex = ''rgb\([[:xdigit:]]{3}([[:xdigit:]]{3})?\)'';
    rgbDecimal = ''rgb\(${patterns.rgbValue}, *${patterns.rgbValue}, *${patterns.rgbValue}\)'';
    legacy = ''0x[[:xdigit:]]{8}'';
    color = concatStringsSep "|" [
      patterns.rgbaHex
      patterns.rgbaDecimal
      patterns.rgbHex
      patterns.rgbDecimal
      patterns.legacy
    ];
  };

  mkToggleableRules = name:
    mkRegexTarget {
      inherit name;
      regex = [patterns.onOpt];
      optional = true;
    };

  toggleTargets = builtins.listToAttrs (map (name: {
      inherit name;
      value = mkToggleableRules name;
    })
    toggleableRules);

  types =
    {
      workspace = mkRegexTarget {
        name = "workspace";
        regex = attrValues {
          inherit (patterns) numericId relative monitorRelative empty name special previous openWorkspace;
        };
        extraRegex = "( +silent)?";
      };

      monitor = mkRegexTarget {
        name = "monitor";
        regex = attrValues {
          inherit (patterns) numericId ident;
        };
      };

      group = mkRegexTarget {
        name = "group";
        regex = ["set|new|lock|barred|deny|invade|override|unset"];
      };

      size = mkRegexTarget {
        name = "size";
        regex = [
          "([0-9]+|[<>][0-9]+)(%|px)?( ([0-9]+|[<>][0-9]+)(%|px)?)?"
        ];
      };

      move = mkRegexTarget {
        name = "move";
        regex = [
          "(${patterns.coordinate}) (${patterns.coordinate})"
          "cursor (${patterns.percentage}) (${patterns.percentage})"
          "onscreen cursor (${patterns.percentage}) (${patterns.percentage})"
        ];
      };

      border_color = mkRegexTarget {
        name = "border_color";
        regex = [patterns.color];
      };

      idle_inhibit = mkRegexTarget {
        name = "idle_inhibit";
        regex = [patterns.mode];
      };

      opacity = mkRegexTarget {
        name = "opacity";
        regex = let
          opacityValue = "${patterns.alpha}( override)?";
        in [
          opacityValue
          "${opacityValue} ${opacityValue}"
          "${opacityValue} ${opacityValue} ${opacityValue}"
        ];
      };

      rounding_power = mkRegexTarget {
        name = "rounding_power";
        regex = [patterns.float];
      };

      border_size = mkRegexTarget {
        name = "border_size";
        regex = [patterns.int];
      };

      rounding = mkRegexTarget {
        name = "rounding";
        regex = [patterns.int];
      };

      scroll_mouse = mkRegexTarget {
        name = "scroll_mouse";
        regex = [patterns.float];
      };

      scroll_touchpad = mkRegexTarget {
        name = "scroll_touchpad";
        regex = [patterns.float];
      };

      tag = mkRegexTarget {
        name = "tag";
        regex = [''[+-]?[[:alnum:]_]+\*?''];
      };

      max_size = mkRegexTarget {
        name = "max_size";
        regex = ["${patterns.int} ${patterns.int}"];
      };

      min_size = mkRegexTarget {
        name = "min_size";
        regex = ["${patterns.int} ${patterns.int}"];
      };

      animation = mkRegexTarget {
        name = "animation";
        regex = ["(slide)( (left|right|up|down|top|bottom))?|(popin)( ([0-9]+%))?"];
      };

      fullscreen_state = mkRegexTarget {
        name = "fullscreen_state";
        regex = ["[0-3] [0-3]"];
      };

      suppress_event = mkRegexTarget {
        name = "suppress_event";
        regex = ["[a-z_]+( [a-z_]+)*"];
      };

      content = mkRegexTarget {
        name = "content";
        regex = ["none|photo|video|game"];
      };

      no_close_for = mkRegexTarget {
        name = "no_close_for";
        regex = [patterns.int];
      };
    }
    // toggleTargets;
in {
  inherit types;
}
