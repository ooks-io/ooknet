{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.networking) hostName;
  inherit (config.ooknet.secrets) keys;

  mkBuilderMachine = {
    host,
    speedFactor,
    systems ? ["x86_64-linux"],
    supportedFeatures ? ["big-parallel" "kvm" "nixos-test"],
    maxJobs,
  }: {
    inherit speedFactor systems supportedFeatures maxJobs;
    hostName = host;
    protocol = "ssh-ng";
    sshKey = "/home/${admin.name}/.ssh/builder";
  };

  builders = {
    ooksdesk = mkBuilderMachine {
      host = "ooksdesk";
      speedFactor = 16;
      maxJobs = 4;
    };
    ooksmedia = mkBuilderMachine {
      host = "ooksmedia";
      speedFactor = 8;
      maxJobs = 1;
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
