{ lib, config, ... }:

let
  cfg = config.homeModules.console.utility.ssh;
  hasFish = mkIf config.homeModules.console.shell.fish.enable;
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
    programs.fish.interactiveShellInit = hasFish ''
      set -gx SSH_AUTH_SOCK ~/.1password/agent.sock
    '';
  };
  
}
