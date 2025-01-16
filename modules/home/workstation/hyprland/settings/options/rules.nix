{lib, ...}: let
  inherit (lib) concatStringsSep attrValues;
  inherit (lib.types) enum strMatching;

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

  # basic windowrules that can be validated with simple enum

  basicWindowRules = enum [
    "float"
    "tile"
    "fullscreen"
    "maximize"
    "pseudo"
    "noinitialfocus"
    "pin"
    "unset"
    "nomaxsize"
    "stayfocused"
  ];

  # toggleable options
  toggleableRules = [
    # window decoration
    "decorate" # window decorations
    "noborder" # borders
    "noshadow" # shadows
    "norounding" # corner rounding

    # Visual effects
    "noblur" # blur
    "noanim" # animations
    "nodim" # dimming
    "opaque" # opacity enforcement
    "forcergbx" # RGB handling
    "xray" # blur xray mode
    "immediate" # tearing mode

    # Behavior
    "dimaround" # dim around window
    "focusonactivate" # focus on activation request
    "nofocus" # disable focus
    "stayfocused" # keep focus
    "keepaspectratio" # maintain aspect ratio
    "nearestneighbor" # nearest neighbor filtering
    "nomaxsize" # disable max size
    "noshortcutsinhibit" # shortcut inhibiting
    "allowsinput" # XWayland input forcing
    "renderunfocused" # unfocused rendering
    "syncfullscreen" # fullscreen sync
  ];

  # reusable regex pattens to be used in constructing our types
  patterns = {
    # toggles
    onOpt = "1|true|on|yes|0|salse|off|no|toggle|unset";

    # numbers
    float = "[+-]?([0-9]*[.])?[0-9]+";
    int = "[0-9]+";
    alpha = ''(0|0?\.[[:digit:]]+|1|1\.0)'';
    percentage = "[0-9]+(%)?";

    # position
    anchor = "100%-w?-[0-9]+";
    coordinate = "${patterns.percentage}|${patterns.anchor}";
    deg = "(0-360)";

    # identification
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

    # colors
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

  # regex patterns to pass to the workspace rule

  types =
    {
      inherit basicWindowRules;
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

      bordercolor = mkRegexTarget {
        name = "bordercolor";
        regex = [patterns.color];
      };

      idleinhibit = mkRegexTarget {
        name = "idleinhibit";
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

      center = mkRegexTarget {
        name = "center";
        regex = ["[0-1]"];
        optional = true;
      };

      roundingpower = mkRegexTarget {
        name = "roundingpower";
        regex = [patterns.float];
      };

      bordersize = mkRegexTarget {
        name = "bordersize";
        regex = [patterns.int];
      };

      rounding = mkRegexTarget {
        name = "rounding";
        regex = [patterns.int];
      };

      scrollmouse = mkRegexTarget {
        name = "scrollmouse";
        regex = [patterns.float];
      };

      scrolltouchpad = mkRegexTarget {
        name = "scrolltouchpad";
        regex = [patterns.float];
      };

      tag = mkRegexTarget {
        name = "tag";
        regex = [''[+-]?[[:alnum:]_]+\*?''];
      };

      maxsize = mkRegexTarget {
        name = "maxsize";
        regex = ["${patterns.int} ${patterns.int}"];
      };

      minsize = mkRegexTarget {
        name = "minsize";
        regex = ["${patterns.int} ${patterns.int}"];
      };
      animation = mkRegexTarget {
        name = "animation";
        regex = ["(slide)( (left|right|up|down|top|bottom))?|(popin)( ([0-9]+%))?"];
      };
    }
    // toggleTargets;
in {
  inherit types;
}
