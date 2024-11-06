{
  check,
  math,
  ...
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
      assert check.hex.set attrs || throw "Invalid Hex values: r=${toString r}, g=${toString g}, b=${toString b}"; attrs;

    string = r: g: b: let
      str = "${r}${g}${b}";
    in
      assert check.hex.string str || throw "Invalid Hex value: ${str}"; str;
  };

  rgb = {
    string = r: g: b: let
      str = "${toString r},${toString g},${toString b}";
    in
      assert check.rgb.string str || throw "Invalid RBG string format: ${str}"; str;
    set = {
      r,
      g,
      b,
    }: let
      attrs = {inherit r g b;};
    in
      assert check.rgb.set attrs || throw "Invalid RGB values: r=${toString r}, g=${toString g}, b=${toString b}"; attrs;
  };
  hsl = {
    string = h: s: l: let
      str = "${toString (round h)}, ${toString (round (s * 100))}%, ${toString (round (l * 100))}%";
    in
      assert check.hsl.string str || throw "Invalid HSL values: ${str}"; str;
    set = {
      h,
      s,
      l,
    }: let
      attrs = {inherit h s l;};
    in
      assert check.hsl.set attrs || throw "Invalid HSL values: h=${toString h}, s=${toString s}, l=${toString l}"; attrs;
  };
in {inherit hex hsl rgb;}
