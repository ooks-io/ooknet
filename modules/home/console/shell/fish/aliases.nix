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
      gitedit = "cd (git rev-parse --show-toplevel); nvim -c 'Telescope find_files'; cd -";
    };
    shellAbbrs = {
      f = "cd $FLAKE";
      s = "cd $KUNZEN";
      fe = "$EDITOR (git rev-parse --show-toplevel) -c 'Telescope find_files'";
      repl = "nix repl --expr 'import <nixpkgs> {}'";

      nswitch = "${getExe nh} os switch";
    };
  };
}
