{ lib, config, ... }:

let
  cfg = config.ooknet.console.utility.ssh;
  hasFish = mkIf config.ooknet.console.shell.fish.enable;
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
    programs.fish.interactiveShellInit = hasFish /* fish */ ''
      set -gx SSH_AUTH_SOCK ~/.1password/agent.sock
    '';
  };
}
