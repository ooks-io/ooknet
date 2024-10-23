{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs) bat eza dust nh;
in {
  programs.fish = {
    shellAliases = {
      cat = "${getExe bat}";
      ls = "${getExe eza} -a --icons --group-directories-first";
      lst = "${getExe eza} -T -L 5 --icons --group-directories-first";
      du = "${getExe dust}";
      gitroot = "cd (git rev-parse --show-toplevel)";
    };
    shellAbbrs = {
      f = "cd $FLAKE";
      fe = "$EDITOR $FLAKE";

      nswitch = "${getExe nh} os switch";
    };
  };
}
