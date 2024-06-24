{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge hm;
  cfg = config.ooknet.productivity.notes.obsidian;
  notes = config.ooknet.desktop.notes;
  # admin = osConfig.ooknet.host.admin;
  # TODO: use admin.githubUsername
  notesRepo = "git@github.com:ooks-io/notes.git";
  notesPath = "${config.xdg.userDirs.documents}/notes";
in

{
  config = mkMerge [ 
    (mkIf (cfg.enable || notes == "obsidian") {
      home.packages = [ pkgs.obsidian ];
      home.activation.cloneObsidianVault = hm.dag.entryAfter ["installPackages"] /* shell */ ''
        if ! [ -d "${notesPath}" ]; then
          $DRY_RUN_CMD git clone ${notesRepo} ${notesPath}
        fi
      '';
    })

    (mkIf (notes == "obsidian") {
      ooknet.binds.notes = "obsidian";
    })
  ];
}
