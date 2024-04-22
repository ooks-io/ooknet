{ lib, config, ... }:

let
  cfg = config.systemModules.networking;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
  phoneKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINredx07UAk2l1wUPujYnmJci1+XEmcUuSX0DIYg6Vzz";
  inherit (lib) mkIf mkDefault mkEnableOption;
in

{
  options.systemModules.networking.ssh = mkEnableOption "Enable ssh networking module";

  config = mkIf cfg.ssh {
    environment.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";

    users.users.ooks.openssh.authorizedKeys.keys = [ key ];

    services.openssh = {
      enable = true;
      settings = {
        UseDns = false;
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        UsePam = "no";
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        KbdInteractiveAuthentication = mkDefault false;
      };
    };
    programs.ssh = {
      knownHosts = {
        "192.168.1.36".publicKey = phoneKey;
      };
    };
  };
}
