{
  math,
  types,
  translate,
}: let
  # base modification function
  modifyHSL = hexStr: modifications: let
    # convert hex to HSL
    hslSet = translate.hex.toHSL.set hexStr;
    # apply modifications to get new HSL values
    newHSL = types.hsl.set {
      inherit (hslSet) h; # keep hue
      l = math.clamp 0.0 1.0 (hslSet.l + (modifications.l or 0.0));
      s = math.clamp 0.0 1.0 (hslSet.s + (modifications.s or 0.0));
    };
    # convert back to hex
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

  mkDarkColorScheme = {
    shades,
    primary,
    secondary,
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
  } @ args: {
    shade-50 = args.shades."50";
    shade-100 = args.shades."100";
    shade-150 = args.shades."150";
    shade-200 = args.shades."200";
    shade-250 = args.shades."250";
    shade-300 = args.shades."300";
    shade-350 = args.shades."350";
    shade-400 = args.shades."400";
    shade-450 = args.shades."450";
    shade-500 = args.shades."500";
    shade-550 = args.shades."550";
    shade-600 = args.shades."600";
    shade-650 = args.shades."650";
    shade-700 = args.shades."700";
    shade-750 = args.shades."750";
    shade-800 = args.shades."800";
    shade-850 = args.shades."850";
    shade-900 = args.shades."900";

    primary = mkDarkColorScale args.primary;
    secondary = {
      up-1 = args.shade."550";
      up-2 = args.shade."500";
      up-3 = args.shade."450";
      up-4 = args.shade."400";
      up-5 = args.shade."350";
      up-6 = args.shade."300";
      up-7 = args.shade."250";
      up-8 = args.shade."200";
      up-9 = args.shade."150";
      up-10 = args.shade."100";
      base = args.shade."700";
      down-1 = args.shade."650";
      down-2 = args.shade."700";
    };
    red = mkDarkColorScale args.red;
    orange = mkDarkColorScale args.orange;
    yellow = mkDarkColorScale args.yellow;
    olive = mkDarkColorScale args.olive;
    green = mkDarkColorScale args.green;
    teal = mkDarkColorScale args.teal;
    blue = mkDarkColorScale args.blue;
    violet = mkDarkColorScale args.violet;
    purple = mkDarkColorScale args.purple;
    pink = mkDarkColorScale args.pink;
    brown = mkDarkColorScale args.brown;
  };
in {
  inherit lighten darken saturate desaturate mkLightColorScale mkDarkColorScale mkDarkColorScheme;
}
