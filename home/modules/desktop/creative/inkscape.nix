{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.creative.inkscape;
in

{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.inkscape-with-extensions ];
  };
}

