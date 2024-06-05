{ lib, config, pkgs, ...}:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.media.video.youtube;
in

{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.youtube-tui ];
    programs.yt-dlp = {
      enable = true;
    };
  };
}
