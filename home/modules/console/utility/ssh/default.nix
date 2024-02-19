{ lib, config, ... }:

let
  cfg = config.homeModules.console.utility.ssh;
in

{

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = /* config */''
        Host *
            IdentitiesOnly=yes
            IdentityAgent "~/.1password/agent.sock"
      '';
    };
  };
  
}
