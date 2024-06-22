{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.sourcegraph;
in

{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.src-cli ];
  };
}
