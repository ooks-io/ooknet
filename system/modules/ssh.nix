{ lib, config, ... }:

let
  cfg = config.systemModules.openssh;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
in

{
  options.systemModules = {
    openssh = {
      enable = lib.mkEnableOption "enable openssh system module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";

    users.users.ooks.openssh.authorizedKeys.keys = [ key ];

    services.openssh = {
      enable = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
      };
    };
    
  };
  
}
