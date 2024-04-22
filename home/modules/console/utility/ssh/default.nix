{ lib, config, ... }:

let
  cfg = config.homeModules.console.utility.ssh;
  fish = config.homeModules.console.shell.fish;
  inherit (lib) mkIf;
in

{

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = /* config */''
        Host *
            IdentityAgent "~/.1password/agent.sock"
      '';
    };
    fish.interactiveShellInit = mkIf fish.enable ''
      set -gx SSH_AUTH_SOCK ~/.1password/agent.sock
    '';
  };
  
}
