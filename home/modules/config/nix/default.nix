{ lib, config, pkgs, outputs, ... }:

let
  cfg = config.ooknet.config.nix;
in

{
  config = lib.mkIf cfg.enable {

    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
        experimental-features = [ "nix-command" "flakes" "repl-flake" ];
        warn-dirty = false;
      };
    };
  };
}
