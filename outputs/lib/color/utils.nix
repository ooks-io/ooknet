{
  math,
  types,
  translate,
  check,
}: let
  # Base modification functions
  modifyHSL = hexStr: modifications: let
    hslSet = translate.hex.toHSL.set hexStr;
    newHSL = types.hsl.set {
      inherit (hslSet) h;
      l =
        if modifications ? absoluteL
        then modifications.l
        else math.clamp 0.0 1.0 (hslSet.l + (modifications.l or 0.0));
      s =
        if modifications ? absoluteS
        then modifications.l
        else math.clamp 0.0 1.0 (hslSet.s + (modifications.s or 0.0));
    };
    rgbSet = translate.hsl.toRGB.set newHSL;
  in
    translate.rgb.toHex.string rgbSet;

  lighten = amount: hexStr:
    modifyHSL hexStr {l = amount / 100.0;};

  darken = amount: hexStr:
    modifyHSL hexStr {l = (amount * -1) / 100.0;};

  saturate = amount: hexStr:
    modifyHSL hexStr {s = amount / 100.0;};

  desaturate = amount: hexStr:
    modifyHSL hexStr {s = (amount * -1) / 100.0;};

  absoluteLum = amount: hexStr:
    modifyHSL hexStr {
      absoluteL = true;
      l = amount / 100.0;
    };

  mkDarkColorScale = base: {
    hard4 = lighten 12 base;
    hard3 = lighten 9 base;
    hard2 = lighten 6 base;
    hard1 = lighten 3 base;
    inherit base;
    soft1 = darken 3 base;
    soft2 = darken 6 base;
    soft3 = darken 9 base;
    soft4 = darken 12 base;
  };

  mkLightColorScale = base: {
    soft4 = lighten 12 base;
    soft3 = lighten 9 base;
    soft2 = lighten 6 base;
    soft1 = lighten 3 base;
    inherit base;
    hard1 = darken 3 base;
    hard2 = darken 6 base;
    hard3 = darken 9 base;
    hard4 = darken 12 base;
  };

  mkAlert = color: {
    fg = absoluteLum 19 color;
    bg = absoluteLum 79 color;
    border = color;
    base = color;
  };

  # core color scheme generator
  mkColorScheme = {
    type ? "dark",
    slug,
    neutrals ? {},
    primary,
    red,
    orange,
    yellow,
    olive,
    green,
    teal,
    blue,
    violet,
    purple,
    pink,
    brown,
  } @ args: let
    # Select scale function based on theme type
    mkColorScale =
      if type == "dark"
      then mkDarkColorScale
      else mkLightColorScale;

    validNeutrals = check.neutrals args;

    # Generate color scales
    colors = {
      red = mkColorScale args.red;
      orange = mkColorScale args.orange;
      yellow = mkColorScale args.yellow;
      olive = mkColorScale args.olive;
      green = mkColorScale args.green;
      teal = mkColorScale args.teal;
      blue = mkColorScale args.blue;
      violet = mkColorScale args.violet;
      purple = mkColorScale args.purple;
      pink = mkColorScale args.pink;
      brown = mkColorScale args.brown;
    };

    # Theme-specific configurations
    theme =
      if type == "dark"
      then {
        semantic = {
          layout = {
            body = args.neutrals."750";
            header = args.neutrals."800";
            footer = args.neutrals."800";
            menu = args.neutrals."800";
          };
          border = {
            base = args.neutrals."150";
            active = args.neutrals."150";
            inactive = args.neutrals."600";
          };
          typography = {
            text = args.neutrals."150";
            text-bright = args.neutrals."100";
            subtext = args.neutrals."300";
            contrast-text = args.neutrals."800";
          };
        };
        secondary = {
          hard4 = args.neutrals."300";
          hard3 = args.neutrals."350";
          hard2 = args.neutrals."400";
          hard1 = args.neutrals."450";
          base = args.neutrals."500";
          soft1 = args.neutrals."550";
          soft2 = args.neutrals."600";
          soft3 = args.neutrals."650";
          soft4 = args.neutrals."700";
        };
        base00 = args.neutrals."800";
        base01 = args.neutrals."700";
        base02 = args.neutrals."600";
        base03 = args.neutrals."450";
        base04 = args.neutrals."300";
        base05 = args.neutrals."150";
        base06 = args.neutrals."100";
        base07 = args.neutrals."50";
        base10 = args.neutrals."850";
        base11 = args.neutrals."900";
      }
      else {
        semantic = {
          layout = {
            body = args.neutrals."50";
            header = args.neutrals."150";
            footer = args.neutrals."150";
            menu = args.neutrals."150";
          };
          border = {
            base = args.neutrals."800";
            active = args.neutrals."800";
            inactive = args.neutrals."300";
          };
          typography = {
            text = args.neutrals."800";
            text-bright = args.neutrals."850";
            subtext = args.neutrals."600";
            text-contrast = args.neutrals."50";
          };
        };
        secondary = {
          hard4 = args.neutrals."400";
          hard3 = args.neutrals."350";
          hard2 = args.neutrals."300";
          hard1 = args.neutrals."250";
          base = args.neutrals."200";
          soft1 = args.neutrals."150";
          soft2 = args.neutrals."100";
          soft3 = args.neutrals."50";
          soft4 = args.neutrals."50";
        };
        base00 = args.neutrals."150";
        base01 = args.neutrals."250";
        base02 = args.neutrals."450";
        base03 = args.neutrals."550";
        base04 = args.neutrals."650";
        base05 = args.neutrals."800";
        base06 = args.neutrals."850";
        base07 = args.neutrals."900";
        base10 = args.neutrals."100";
        base11 = args.neutrals."50";
      };
  in {
    inherit slug;
    # Common structure for both themes
    neutrals = {
      inherit
        (validNeutrals)
        "50"
        "100"
        "150"
        "200"
        "250"
        "300"
        "350"
        "400"
        "450"
        "500"
        "550"
        "600"
        "650"
        "700"
        "750"
        "800"
        "850"
        "900"
        ;
    };

    error = mkAlert args.red;
    warning = mkAlert args.yellow;
    success = mkAlert args.green;
    note = mkAlert args.blue;
    tip = mkAlert args.teal;

    inherit
      (colors)
      red
      orange
      yellow
      olive
      green
      teal
      blue
      violet
      purple
      pink
      brown
      ;

    primary = mkColorScale args.primary;

    inherit (theme) secondary;
    inherit (theme.semantic) layout border typography;

    syntax = {
      string = args.green;
      number = args.purple;
      float = args.purple;
      boolean = args.purple;
      type = args.yellow;
      structure = args.orange;
      statement = args.red;
      label = args.orange;
      operator = args.orange;
      identifier = args.blue;
      function = args.green;
      storageClass = args.orange;
      constant = args.teal;
      exception = args.red;
      preproc = args.purple;
      include = args.purple;
      define = args.purple;
      macro = args.teal;
      preCondit = args.purple;
      special = args.yellow;
      specialChar = args.yellow;
      comment = "${theme.semantic.typography.subtext}";
      todo = args.purple;
      tag = args.teal;
    };

    inherit
      (theme)
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base10
      base11
      ;
    base08 = args.red;
    base09 = args.orange;
    base0A = args.yellow;
    base0B = args.green;
    base0C = args.teal;
    base0D = args.blue;
    base0E = args.purple;
    base0F = args.brown;
    base12 = "${colors.red.hard2}";
    base13 = "${colors.yellow.hard2}";
    base14 = "${colors.green.hard2}";
    base15 = "${colors.teal.hard2}";
    base16 = "${colors.blue.hard2}";
    base17 = "${colors.purple.hard2}";
  };

  # wrappers
  mkDarkColorScheme = args: mkColorScheme (args // {type = "dark";});
  mkLightColorScheme = args: mkColorScheme (args // {type = "light";});
in {
  inherit lighten darken saturate desaturate;
  inherit mkDarkColorScale mkLightColorScale;
  inherit mkColorScheme mkDarkColorScheme mkLightColorScheme;
}
