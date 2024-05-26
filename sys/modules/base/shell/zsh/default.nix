{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  adminShell = config.ooknet.host.admin.shell;
  cfg = config.ooknet.shell.zsh;
in

{

  options.ooknet.shell.zsh.enable = mkEnableOption "Enable zsh module";

  config = mkIf (adminShell == "zsh" || cfg.enable) {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
        async = true;
      };
    };
    environment.pathsToLink = ["/share/zsh"];
  };
}
