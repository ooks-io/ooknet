{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  adminShell = config.systemModules.host.admin.shell;
  cfg = config.systemModules.shell.zsh;
in

{
  config = mkIf (adminShell == "bash" || cfg.enable) {
    programs.bash = {
      enable = true;
    };
    environment.pathsToLink = ["/share/bash-completion"];
  };
}

