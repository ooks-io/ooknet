{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  adminShell = config.ooknet.host.admin.shell;
  cfg = config.ooknet.shell.zsh;
in

{
  config = mkIf (adminShell == "bash" || cfg.enable) {
    programs.bash = {
      enable = true;
    };
    environment.pathsToLink = ["/share/bash-completion"];
  };
}

