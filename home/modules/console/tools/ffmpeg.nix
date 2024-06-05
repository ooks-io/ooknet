{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.ffmpeg;
in

{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.ffmpeg ];
  };
}
