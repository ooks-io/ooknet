{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  userShell = config.systemModules.user.shell;
in

{
  config = mkIf (userShell == "zsh") {
    users.users.ooks.shell = pkgs.zsh;
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
