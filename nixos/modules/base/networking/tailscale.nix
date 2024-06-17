{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.host.networking.tailscale;
  inherit (config.services) tailscale;
  inherit (lib) mkIf mkDefault mkBefore;
in

{
  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = mkDefault "both";
      permitCertUid = "root";
      extraUpFlags = cfg.flags.final;
      authKeyFile = "${config.age.secrets.tailscale-auth.path}";
    };
    networking.firewall = {
      allowedUDPPorts = [tailscale.port];
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";
    };
    users = {
      groups.tailscaled = {};
      users.tailscaled = {
        group = "tailscaled";
        isSystemUser = true;
      };
    };
    systemd.network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];

    environment.systemPackages = [ pkgs.tailscale ];

    # disable tailscale logging
    systemd.services.tailscaled.serviceConfig.Environment = mkBefore ["TS_NO_LOGS_NO_SUPPORT"];
  };
}
