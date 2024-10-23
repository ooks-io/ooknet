{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) concatLists optionals;
  inherit (config.ooknet) host;
  inherit (config.ooknet.host) admin;
  inherit (config.services) tailscale;
in {
  services.tailscale = {
    enable = true;

    # "client"/"both" - reverce path filtering will be set to loose instead of strict
    # "server"/"both" - ip forwarding will be enabled
    useRoutingFeatures = "both";

    # user that can fetch tailscale tls certs
    permitCertUid = "root";

    # authentication key for auto connect service
    authKeyFile = config.age.secrets.tailscale-auth.path;

    # flags to pass to the auto-connect service
    extraUpFlags = concatLists [
      ["--ssh"]
      (optionals (admin.name != null) ["--opterator ${admin.name}"])
      (optionals host.exitNode ["--advertise-exit-node"])
    ];

    # opens relevant tailscale ports over UDP
    openFirewall = true;
  };

  # trust tailscale default interface
  networking.firewall.trustedInterfaces = ["${tailscale.interfaceName}"];

  # credit github:notashelf/nyx
  systemd = {
    # ignore tailscale interface for wait-online service
    network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];

    # only start tailscale daemon after network-online and systemd-resolved services
    # are up
    services.tailscaled = {
      after = ["network-online.target" "systemd-resolved.service"];
      wants = ["network-online.target" "systemd-resolved.service"];
    };
  };
}
