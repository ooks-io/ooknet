{
  check,
  math,
}: let
  inherit (math) round;
  hex = {
    set = {
      r,
      g,
      b,
    }: let
      attrs = {inherit r g b;};
    in
      check.hex.set attrs;

    string = r: g: b: let
      str = "${r}${g}${b}";
    in
      check.hex.string str;
  };

  rgb = {
    string = r: g: b: let
      str = "${toString r},${toString g},${toString b}";
    in
      check.rgb.string str;
    set = {
      r,
      g,
      b,
    }: let
      attrs = {inherit r g b;};
    in
      check.rgb.set attrs;
  };
  hsl = {
    string = h: s: l: let
      str = "${toString (round h)}, ${toString (round (s * 100))}%, ${toString (round (l * 100))}%";
    in
      check.hsl.string str;
    set = {
      h,
      s,
      l,
    }: let
      attrs = {inherit h s l;};
    in
      check.hsl.set attrs;
  };
in {inherit hex hsl rgb;}
