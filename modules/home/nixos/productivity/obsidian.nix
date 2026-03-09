{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem hm;
  inherit (osConfig.ooknet.workstation) profiles;
  # admin = osConfig.ooknet.host.admin;
  # TODO: use admin.githubUsername
  notesRepo = "git@github.com:ooks-io/notes.git";
  notesPath = "${config.xdg.userDirs.extraConfig.NOTES}";
in {
  config = mkIf (elem "productivity" profiles) {
    home.packages = [pkgs.obsidian];
    home.activation.cloneObsidianVault =
      hm.dag.entryAfter ["installPackages"]
      /*
      shell
      */
      ''
        if ! [ -d "${notesPath}" ]; then
          $DRY_RUN_CMD git clone ${notesRepo} ${notesPath}
        fi
      '';

    ooknet.binds.notes = "obsidian";
  };
}
