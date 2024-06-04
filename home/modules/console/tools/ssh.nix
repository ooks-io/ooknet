{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.ssh;
  admin = osConfig.ooknet.host.admin;
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
    programs.fish.interactiveShellInit = mkIf (admin.shell == "fish") /* fish */ ''
      set -gx SSH_AUTH_SOCK ~/.1password/agent.sock
    '';
  };
}
