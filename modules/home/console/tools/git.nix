{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.host) admin;
  cfg = osConfig.ooknet.console.tools.git;
in {
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = admin.gitName;
      userEmail = admin.gitEmail;
      ignores = [".direnv" "result"];
      lfs.enable = true;
    };

    home.packages = attrValues {
      inherit (pkgs) lazygit gh;
    };
  };
}
