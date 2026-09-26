{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.networking) hostName;
  inherit (config.ooknet.secrets) keys;

  # full magicdns names, bare names go through the lan search domain first
  # and the router dns can hang for minutes
  tailnet = "taila3ca6.ts.net";

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
      host = "ooksdesk.${tailnet}";
      speedFactor = 16;
      maxJobs = 4;
    };
    ooksmedia = mkBuilderMachine {
      host = "ooksmedia.${tailnet}";
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
          command="nix-daemon --stdio",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ${keys.users.builder}
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

  # the daemon connects as root, declare builder host keys so a fresh or
  # renamed host doesnt fail verification. these are the live sshd keys,
  # kunzen keys.hosts for these two are stale
  programs.ssh.knownHosts = {
    ooksdesk = {
      hostNames = ["ooksdesk" "ooksdesk.${tailnet}"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLkmmdypXVGzOkQhUDQf8VXC4GhQ3sQp3U4nb5GrryM";
    };
    ooksmedia = {
      hostNames = ["ooksmedia" "ooksmedia.${tailnet}"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyGQHIvKtmdVOi/1R+iUnnYTFnI0xkuWN2Eg56+fKmd";
    };
  };
}
