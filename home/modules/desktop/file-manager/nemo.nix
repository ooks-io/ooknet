{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge;
  cfg = config.ooknet.fileManager.nemo;
  fileManager = config.ooknet.desktop.fileManager;
  nemoMime = {
    "inode/directory" = ["nemo.desktop"];
  };
in

{
  config = mkMerge [
    (mkIf (cfg.enable || fileManager == "nemo") {
      home.packages = [ pkgs.cinnamon.nemo-with-extensions ];
    })

    (mkIf (fileManager == "nemo") {
     ooknet.binds.fileManager = "nemo"; 
      xdg.mimeApps = {
        associations.added = nemoMime;
        defaultApplications = nemoMime;    
      };
    })
  ];
}
