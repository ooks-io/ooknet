{lib}: let
  inherit (lib) min max;
  inherit (builtins) floor ceil;

  # basic math functions
  # credits to github:xddxdd/nix-math

  abs = x:
    if x < 0
    then 0 - x
    else x;

  clamp = a: b: v: min (max v (min a b)) (max a b);

  round = x:
    if (x - floor x) < 0.5
    then floor x
    else ceil x;

  hasFraction = x: let
    splitted = lib.splitString "." (builtins.toString x);
  in
    builtins.length splitted >= 2 && builtins.length (builtins.filter (ch: ch != "0") (lib.stringToCharacters (builtins.elemAt splitted 1))) > 0;

  div = a: b: let
    divideExactly = !(hasFraction (1.0 * a / b));
    offset =
      if divideExactly
      then 0
      else (0 - 1);
  in
    if b < 0
    then offset - div a (0 - b)
    else if a < 0
    then offset - div (0 - a) b
    else floor (1.0 * a / b);

  mod = a: b:
    if b < 0
    then 0 - mod (0 - a) (0 - b)
    else if a < 0
    then mod (b - mod (0 - a) b) b
    else a - b * (div a b);
in {
  inherit round mod abs hasFraction clamp;
}
