{
  math,
  types,
  lib,
}: let
  inherit (builtins) substring;
  inherit (lib) min max;
  hex = {
    toSet = string:
      types.hex.set {
        r = substring 0 2 string;
        g = substring 2 2 string;
        b = substring 4 2 string;
      };
    toRGB = let
      dictionary = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
        "A" = 10;
        "B" = 11;
        "C" = 12;
        "D" = 13;
        "E" = 14;
        "F" = 15;
      };
    in {
      # Converts a hex pair directly to RGB value (0-255)
      pair = hexPair: let
        high = dictionary.${substring 0 1 hexPair};
        low = dictionary.${substring 1 1 hexPair};
      in
        (high * 16) + low;

      # Converts a hex set to RGB set
      set = hexSet:
        types.rgb.set {
          r = hex.toRGB.pair hexSet.r;
          g = hex.toRGB.pair hexSet.g;
          b = hex.toRGB.pair hexSet.b;
        };
      string = hexStr: let
        rgbSet = hex.toRGB.set (hex.toSet hexStr);
      in
        types.rgb.string rgbSet.r rgbSet.g rgbSet.b;
    };
    toHSL = {
      set = hexStr: let
        rgbSet = hex.toRGB.set (hex.toSet hexStr);
      in
        rgb.toHSL.set rgbSet;

      string = hexStr: let
        hslSet = hex.toHSL.set hexStr;
      in
        types.hsl.string hslSet.h hslSet.s hslSet.l;
    };
  };
  rgb = {
    toHex = {
      set = rgbSet: let
        # Convert decimal to two-digit hex
        toHexPair = num: let
          hex = lib.toLower (lib.toHexString num);
          # Pad with leading zero if single digit
          padded =
            if (builtins.stringLength hex) == 1
            then "0${hex}"
            else hex;
        in
          padded;
      in
        types.hex.set {
          r = toHexPair rgbSet.r;
          g = toHexPair rgbSet.g;
          b = toHexPair rgbSet.b;
        };

      string = rgbStr: let
        hexSet = rgb.toHex.set rgbStr;
      in
        types.hex.string hexSet.r hexSet.g hexSet.b;
    };
    toHSL = {
      set = rgbSet: let
        # Normalize RGB values to 0-1 range
        r = rgbSet.r / 255.0;
        g = rgbSet.g / 255.0;
        b = rgbSet.b / 255.0;

        # Find min, max and delta
        c_max = max (max r g) b;
        c_min = min (min r g) b;
        delta = c_max - c_min;

        # Calculate HSL values
        h =
          if delta == 0.0
          then 0.0
          else if c_max == r
          then 60.0 * (math.mod ((g - b) / delta) 6)
          else if c_max == g
          then 60.0 * ((b - r) / delta + 2)
          else 60.0 * ((r - g) / delta + 4);

        l = (c_max + c_min) / 2;

        s =
          if delta == 0.0
          then 0.0
          else delta / (1 - (math.abs (2 * l - 1)));
      in
        types.hsl.set {
          inherit h;
          s = math.clamp 0.0 1.0 s;
          l = math.clamp 0.0 1.0 l;
        };

      string = rgbStr: let
        hslSet = rgb.toHSL.set (hex.toRGB.set (hex.toSet rgbStr));
      in
        types.hsl.string hslSet.h hslSet.s hslSet.l;
    };
  };
  hsl = {
    toRGB = {
      set = hslSet: let
        inherit (hslSet) h s l;

        # Calculate chroma
        c = (1 - (math.abs (2 * l - 1))) * s;
        # Calculate h prime (h')
        hp = h / 60.0;
        # Calculate x
        x = c * (1 - math.abs ((math.mod hp 2) - 1));
        # Calculate m
        m = l - c / 2;

        # Get initial RGB values based on h'
        rgb' =
          if hp <= 1
          then {
            r = c;
            g = x;
            b = 0;
          }
          else if hp <= 2
          then {
            r = x;
            g = c;
            b = 0;
          }
          else if hp <= 3
          then {
            r = 0;
            g = c;
            b = x;
          }
          else if hp <= 4
          then {
            r = 0;
            g = x;
            b = c;
          }
          else if hp <= 5
          then {
            r = x;
            g = 0;
            b = c;
          }
          else {
            r = c;
            g = 0;
            b = x;
          };
        # Final RGB values
      in
        types.rgb.set {
          r = math.round ((rgb'.r + m) * 255);
          g = math.round ((rgb'.g + m) * 255);
          b = math.round ((rgb'.b + m) * 255);
        };

      string = hslStr: let
        rgbSet = hsl.toRGB.set hslStr;
      in
        types.rgb.string rgbSet.r rgbSet.g rgbSet.b;
    };
    toHex = {
      set = {};
      string = color: color;
    };
  };
in {inherit hex hsl rgb;}
