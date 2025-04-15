{pkgs, ...}: let
  nemoMime = {
    "inode/directory" = ["nemo.desktop"];
  };
in {
  home.packages = [pkgs.nemo-with-extensions];
  xdg.mimeApps = {
    associations.added = nemoMime;
    defaultApplications = nemoMime;
  };
  ooknet.binds.fileManager = "nemo";
}
