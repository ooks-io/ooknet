{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.media.video.mpv;
in
{
  config = {
    programs.mpv = lib.mkIf cfg.enable {
      enable = true;
    };
  };
}
