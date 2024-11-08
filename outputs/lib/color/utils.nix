{
  math,
  types,
  translate,
}: let
  # Base modification functions
  modifyHSL = hexStr: modifications: let
    hslSet = translate.hex.toHSL.set hexStr;
    newHSL = types.hsl.set {
      inherit (hslSet) h;
      l = math.clamp 0.0 1.0 (hslSet.l + (modifications.l or 0.0));
      s = math.clamp 0.0 1.0 (hslSet.s + (modifications.s or 0.0));
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

  # opinionated scale generators for light/dark themes
  # lighter/darker shades always desaturate
  mkDarkColorScale = base: {
    up4 = desaturate 24 (lighten 12 base);
    up3 = desaturate 18 (lighten 9 base);
    up2 = desaturate 12 (lighten 6 base);
    up1 = desaturate 6 (lighten 3 base);
    inherit base;
    down1 = desaturate 6 (darken 3 base);
    down2 = desaturate 12 (darken 6 base);
    down3 = desaturate 18 (darken 9 base);
    down4 = desaturate 24 (darken 12 base);
  };

  mkLightColorScale = base: {
    down4 = desaturate 24 (lighten 12 base);
    down3 = desaturate 18 (lighten 9 base);
    down2 = desaturate 12 (lighten 6 base);
    down1 = desaturate 6 (lighten 3 base);
    inherit base;
    up1 = desaturate 6 (darken 3 base);
    up2 = desaturate 12 (darken 6 base);
    up3 = desaturate 18 (darken 9 base);
    up4 = desaturate 24 (darken 12 base);
  };

  # core color scheme generator
  mkColorScheme = {
    type ? "dark",
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
    colorScale =
      if type == "dark"
      then mkDarkColorScale
      else mkLightColorScale;

    # Generate color scales
    colorScales = {
      red = colorScale args.red;
      orange = colorScale args.orange;
      yellow = colorScale args.yellow;
      olive = colorScale args.olive;
      green = colorScale args.green;
      teal = colorScale args.teal;
      blue = colorScale args.blue;
      violet = colorScale args.violet;
      purple = colorScale args.purple;
      pink = colorScale args.pink;
      brown = colorScale args.brown;
    };

    # Theme-specific configurations
    themeConfig =
      if type == "dark"
      then {
        semantic = {
          body = args.neutrals."700";
          header = args.neutrals."800";
          footer = args.neutrals."800";
          menu = args.neutrals."800";
          border = args.neutrals."150";
          border-active = args.neutrals."150";
          border-inactive = args.neutrals."600";
          text = args.neutrals."150";
          text-bright = args.neutrals."100";
          subtext = args.neutrals."300";
        };
        secondary = {
          up-4 = args.neutrals."400";
          up-3 = args.neutrals."450";
          up-2 = args.neutrals."500";
          up-1 = args.neutrals."550";
          base = args.neutrals."700";
          down-1 = args.neutrals."750";
          down-2 = args.neutrals."800";
          down-3 = args.neutrals."850";
          down-4 = args.neutrals."900";
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
          body = args.neutrals."50";
          header = args.neutrals."150";
          footer = args.neutrals."150";
          menu = args.neutrals."150";
          border = args.neutrals."800";
          border-active = args.neutrals."800";
          border-inactive = args.neutrals."300";
          text = args.neutrals."800";
          text-bright = args.neutrals."850";
          subtext = args.neutrals."600";
        };
        secondary = {
          up-4 = args.neutrals."400";
          up-3 = args.neutrals."350";
          up-2 = args.neutrals."300";
          up-1 = args.neutrals."250";
          base = args.neutrals."200";
          down-1 = args.neutrals."150";
          down-2 = args.neutrals."100";
          down-3 = args.neutrals."50";
          down-4 = args.neutrals."50";
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
    # Common structure for both themes
    neutrals = {
      inherit
        (args.neutrals)
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

    inherit
      (colorScales)
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

    primary = colorScale args.primary;

    inherit (themeConfig) semantic secondary;

    # Status colors (same structure for both themes)
    error = {
      bg = "${colorScales.red.base}";
      bg-active = "${colorScales.red.down1}";
      bg-hover = "${colorScales.red.down2}";
      text = "${themeConfig.semantic.text-bright}";
      border = "${colorScales.red.up2}";
    };

    success = {
      bg = "${colorScales.green.base}";
      bg-active = "${colorScales.green.down1}";
      bg-hover = "${colorScales.green.down2}";
      text = "${themeConfig.semantic.text-bright}";
      border = "${colorScales.green.up2}";
    };

    warning = {
      bg = "${colorScales.yellow.base}";
      bg-active = "${colorScales.yellow.down1}";
      bg-hover = "${colorScales.yellow.down2}";
      text = "${themeConfig.semantic.text-bright}";
      border = "${colorScales.yellow.up2}";
    };

    info = {
      bg = "${colorScales.blue.base}";
      bg-active = "${colorScales.blue.down1}";
      bg-hover = "${colorScales.blue.down2}";
      text = "${themeConfig.semantic.text-bright}";
      border = "${colorScales.blue.up2}";
    };

    tip = {
      bg = "${colorScales.teal.base}";
      bg-active = "${colorScales.teal.down1}";
      bg-hover = "${colorScales.teal.down2}";
      text = "${themeConfig.semantic.text-bright}";
      border = "${colorScales.teal.up2}";
    };

    # Syntax highlighting (same for both themes)
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
      comment = "${themeConfig.semantic.subtext}";
      todo = args.purple;
      tag = args.teal;
    };

    # Base16/24 colors
    inherit
      (themeConfig)
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

    # Generated base colors
    base08 = args.red;
    base09 = args.orange;
    base0A = args.yellow;
    base0B = args.green;
    base0C = args.teal;
    base0D = args.blue;
    base0E = args.purple;
    base0F = args.brown;
    base12 = "${colorScales.red.up2}";
    base13 = "${colorScales.yellow.up2}";
    base14 = "${colorScales.green.up2}";
    base15 = "${colorScales.teal.up2}";
    base16 = "${colorScales.blue.up2}";
    base17 = "${colorScales.purple.up2}";
  };

  # wrappers
  mkDarkColorScheme = args: mkColorScheme (args // {type = "dark";});
  mkLightColorScheme = args: mkColorScheme (args // {type = "light";});
in {
  inherit lighten darken saturate desaturate;
  inherit mkDarkColorScale mkLightColorScale;
  inherit mkColorScheme mkDarkColorScheme mkLightColorScheme;
}
