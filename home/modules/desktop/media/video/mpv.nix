{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.media.video.mpv;
  mpvMime = {
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
  };
in

{
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
    };
    xdg.mimeApps = {
      associations.added = mpvMime;
      defaultApplications = mpvMime;      
    };
  };
}
