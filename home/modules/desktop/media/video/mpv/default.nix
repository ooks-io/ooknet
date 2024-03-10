{ lib, config, pkgs, ... }:

let
  cfg = config.homeModules.desktop.media.video.mpv;
in
{
  config = {
    programs.mpv = lib.mkIf cfg.enable {
      enable = true;
    };
    home.packages = [ pkgs.ffmpeg ];
  };
}
