{ pkgs, ... }:

let
  packages = {
    hyprvolume = pkgs.callPackage ./hyprvolume.nix {};
    hyprbrightness = pkgs.callPackage ./hyprbrightness.nix {};
  };
in
  packages
