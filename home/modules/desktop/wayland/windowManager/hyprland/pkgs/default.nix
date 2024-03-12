{ pkgs, ... }:

let
  packages = {
    hyprvolume = pkgs.callPackage ./hyprvolume.nix {};
    hyprbrightness = pkgs.callPackage ./hyprbrightness.nix {};
    hyprrecord = pkgs.callPackage ./hyprrecord {};
    # Script to help Hyprland quit https://github.com/hyprwm/Hyprland/issues/3558#issuecomment-1848768654
    hyprkillsession = pkgs.callPackage ./hyprkillsession.nix {};
  };
in
  packages
