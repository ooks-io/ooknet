{lib, ...}: let
  inherit (lib) toInt all min max;
  inherit (builtins) isInt isFloat match getAttr hasAttr;

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
      assert isValid || throw "Invalid hex color format: ${color}";
        hexPatternWithHash != null || hexPatternNoHash != null;
    set = color: let
      hasAttributes = all (k: hasAttr k color) ["r" "g" "b"];
      validPattern = all (k: let
        v = getAttr k color;
      in
        match "[[:xdigit:]]{2}" v != null) ["r" "g" "b"];
    in
      hasAttributes && validPattern;
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
      isValid;
    set = color: let
      hasAttributes = all (k: hasAttr k color) ["r" "g" "b"];
      validRanges = all (
        k: let
          v = getAttr k color;
        in
          number v && range 0 255 v
      ) ["r" "g" "b"];
    in
      hasAttributes && validRanges;
  };

  hsl = {
    # TODO: add range checks
    string = color: let
      hslPattern = match "([0-9]{1,3}),[ ]*([0-9]{1,3})%,[ ]*([0-9]{1,3})%" color;
    in
      hslPattern != null;

    set = color: let
      hasAttributes = all (k: hasAttr k color) ["h" "s" "l"];
      validRanges = hue color.h && all (k: unary (getAttr k color)) ["s" "l"];
    in
      hasAttributes && validRanges;
  };
in {inherit range number unary hue hex rgb hsl;}
