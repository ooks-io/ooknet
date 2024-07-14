{ lib, config, ... }:

let
  inherit (lib) mkIf;
  adminShell = config.ooknet.host.admin.shell;
in

{
  config = mkIf (adminShell == "bash" ) {
    programs.bash = {
      enable = true;
    };
    environment.pathsToLink = ["/share/bash-completion"];
  };
}

