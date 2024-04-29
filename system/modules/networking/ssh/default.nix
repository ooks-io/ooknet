{ lib, config, ... }:

let
  inherit (lib) mkIf mkDefault;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
  phoneKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINredx07UAk2l1wUPujYnmJci1+XEmcUuSX0DIYg6Vzz";
  host = config.systemModules.host;
in

{
  config = mkIf (host.type != "phone") {
    environment.sessionVariables.SSH_AUTH_SOCK = "~/.1password/agent.sock";

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

    programs = {
      ssh = {
        knownHosts = {
          "192.168.1.36".publicKey = phoneKey;
        };
      };
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
