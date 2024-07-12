{ lib, config, ... }:

let
  inherit (lib) mkIf;
  adminShell = config.ooknet.host.admin.shell;
in

{
  config = mkIf (adminShell == "zsh") {
  # enable nixpkgs module if zsh is the main users login shell
  # configure with home-manager module
    programs.zsh = {
      enable = true;

      # disable completion option as we configure with home-manager module
      enableCompletion = false;
    };
    environment.pathsToLink = ["/share/zsh"];
  };
}
