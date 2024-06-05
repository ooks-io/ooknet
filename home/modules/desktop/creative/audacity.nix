{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.creative.audacity;
in

{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.audacity ];
  };
}
