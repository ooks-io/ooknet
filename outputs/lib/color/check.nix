{lib, ...}: let
  inherit (lib) toInt all min max;
  inherit (builtins) mapAttrs elemAt isInt isFloat match getAttr hasAttr;

  # basic checks
  range = a: b: v: (v <= max a b) && (v >= min a b);
  number = v: isInt v || isFloat v;
  unary = range 0.0 1.0;
  hue = range 0.0 360.0;

  # type checking
  hex = {
    string = color: let
      hexPatternWithHash = match "#[[:xdigit:]]{6}" color;
      hexPatternNoHash = match "[[:xdigit:]]{6}" color;
      isValid = hexPatternWithHash != null || hexPatternNoHash != null;
    in
      if !isValid
      then abort "Invalid hex color format: ${color}"
      else color;

    set = color: let
      hasAttributes = all (k: hasAttr k color) ["r" "g" "b"];
      validPattern = all (k: let
        v = getAttr k color;
      in
        match "[[:xdigit:]]{2}" v != null) ["r" "g" "b"];
    in
      if !(hasAttributes && validPattern)
      then abort "Invalid Hex values: r=${toString color.r}, g=${toString color.g}, b=${toString color.b}"
      else color;
  };

  rgb = {
    string = color: let
      rgbPattern = match "([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})" color;
      toNum = str: let
        num = toInt str;
      in
        num != null && range 0 255 num;
      isValid = rgbPattern != null && all toNum rgbPattern;
    in
      if !isValid
      then abort "Invalid RGB string: ${color}"
      else color;

    set = color: let
      hasAttributes = all (k: hasAttr k color) ["r" "g" "b"];
      validRanges = all (
        k: let
          v = getAttr k color;
        in
          number v && range 0 255 v
      ) ["r" "g" "b"];
    in
      if !(hasAttributes && validRanges)
      then abort "Invalid RGB set: r=${toString color.r}, g=${toString color.g}, b=${toString color.b}"
      else color;
  };
  hsl = {
    string = color: let
      hslPattern = match "([0-9]{1,3}),[ ]*([0-9]{1,3})%,[ ]*([0-9]{1,3})%" color;
      # Convert matched values to numbers and check ranges
      validateHSL = groups: let
        h = toInt (elemAt groups 0);
        s = toInt (elemAt groups 1);
        l = toInt (elemAt groups 2);
      in
        h
        != null
        && h >= 0
        && h <= 360
        && s != null
        && s >= 0
        && s <= 100
        && l != null
        && l >= 0
        && l <= 100;
      isValid = hslPattern != null && validateHSL hslPattern;
    in
      if !isValid
      then abort "Invalid HSL string: ${color} (expected format: h(0-360),s(0-100%),l(0-100%))"
      else color;

    set = color: let
      hasAttributes = all (k: hasAttr k color) ["h" "s" "l"];
      validRanges =
        color.h
        >= 0
        && color.h <= 360
        && color.s >= 0
        && color.s <= 1.0
        && color.l >= 0
        && color.l <= 1.0;
    in
      if !(hasAttributes && validRanges)
      then
        abort ''
          Invalid HSL set: h=${toString color.h}, s=${toString color.s}, l=${toString color.l}
          Expected:
            h: 0-360
            s: 0.0-1.0
            l: 0.0-1.0
        ''
      else color;
  };

  # validate neutral hex values
  neutrals = {neutrals, ...}:
    mapAttrs (_: value:
      hex.string value)
    neutrals;
in {inherit neutrals range number unary hue hex rgb hsl;}
