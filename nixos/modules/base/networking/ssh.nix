{ lib, config, ... }:

let
  inherit (lib) mkIf mkDefault;
  host = config.ooknet.host;
in

{
  config = mkIf (host.type != "phone") {
    services.openssh = {
      enable = true;
      settings = {
        UseDns = false;
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        UsePAM = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        KbdInteractiveAuthentication = mkDefault false;
      };
    };

    programs = {
      ssh = {
        knownHosts = {
          github = {
            hostNames = ["github.com"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
          };
          gitlab = {
            hostNames = ["gitlab.com"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
          };
        };
      };
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
