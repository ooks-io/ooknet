{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
  imvMime = {
    "image/*" = ["imv.desktop"];
  };
in {
  config = mkIf (elem "media" profiles) {
    programs = {
      imv = {
        enable = true;
      };
    };
    xdg.mimeApps = {
      associations.added = imvMime;
      defaultApplications = imvMime;
    };
  };
}
