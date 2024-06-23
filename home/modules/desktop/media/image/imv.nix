{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.media.image.imv;
  imvMime = {
    "image/*" = ["imv.desktop"];
  };
in

{
  config = mkIf cfg.enable {
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
