{ pkgs, ... }:


pkgs.writeShellScriptBin "hyprrecord" ''
    ${builtins.readFile ./hyprrecord.sh}
  ''




