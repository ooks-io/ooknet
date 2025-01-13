{
  keys,
  config,
  lib,
  self,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.networking) hostName;

  mkBuilderMachine = {
    host,
    speedFactor,
    systems ? ["x86_64-linux"],
    supportedFeatures ? ["big-parallel" "kvm" "nixos-test"],
  }: {
    inherit speedFactor systems supportedFeatures;
    hostName = host;
    maxJobs = self.nixosConfigurations.${host}.config.nix.settings.max-jobs or "auto";
    protocol = "ssh";
    sshKey = "/home/${admin.name}/.ssh/builder";
  };

  builders = {
    ooksdesk = mkBuilderMachine {
      host = "ooksdesk";
      speedFactor = 16;
    };
    ooksmedia = mkBuilderMachine {
      host = "ooksmedia";
      speedFactor = 8;
    };
  };
in {
  users = mkIf (hostName == "ooksdesk" || hostName == "ooksmedia") {
    groups.builder = {};
    users.builder = {
      createHome = false;
      isSystemUser = true;
      useDefaultShell = true;
      group = "builder";
      openssh.authorizedKeys.keys = [
        ''
          command="nix-daemon --stdio",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ${keys.users.${admin.name}}
        ''
      ];
    };
  };
  nix = {
    distributedBuilds = true;
    buildMachines =
      if hostName == "ooksdesk"
      then []
      else if hostName == "ooksmedia"
      then [builders.ooksdesk]
      else [builders.ooksdesk builders.ooksmedia];
  };
}
