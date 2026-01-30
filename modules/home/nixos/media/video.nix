{
  lib,
  osConfig,
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
    programs.mpv = {
      enable = true;
    };
    xdg.mimeApps = {
      associations.added = mpvMime;
      defaultApplications = mpvMime;
    };
  };
}
