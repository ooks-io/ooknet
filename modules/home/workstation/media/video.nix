{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (osConfig.ooknet.workstation) profiles;
  mpvMime = {
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
  };
in {
  config = mkIf (elem "media" profiles) {
    home.packages = [pkgs.jellyfin-media-player];
    programs.mpv = {
      enable = true;
    };
    xdg.mimeApps = {
      associations.added = mpvMime;
      defaultApplications = mpvMime;
    };
  };
}
