{ lib, config, ... }:

let
  cfg = config.systemModules.networking;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
  inherit (lib) mkIf mkEnableOption;
in

{
  options.systemModules.networking.ssh = mkEnableOption "Enable ssh networking module";

  config = mkIf cfg.ssh {
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
