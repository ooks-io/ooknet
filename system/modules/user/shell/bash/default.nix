{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  userShell = config.systemModules.user.shell;
in

{
  config = mkIf (userShell == "bash") {
    users.users.ooks.shell = pkgs.bash;
    programs.bash = {
      enable = true;
    };
    environment.pathsToLink = ["/share/bash-completion"];
  };
}

