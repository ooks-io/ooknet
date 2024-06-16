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
      # permitCertUid = "root";
      extraUpFlags = cfg.flags.final;
    };

    networking.firewall = {
      allowedUDPPorts = [tailscale.port];
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";
    };

    systemd.network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];

    environment.systemPackages = [ pkgs.tailscale ];

    # disable tailscale logging
    systemd.services.tailscaled.serviceConfig.Environment = mkBefore ["TS_NO_LOGS_NO_SUPPORT"];

    systemd.services.tailscale-autoconnect = mkIf cfg.autoconnect {
      description = "Automatic connection to Tailscale";

      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = /* bash */ ''
        sleep 2

        status="$(${tailscale.package}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"

        if [ $status = "Running" ]; then
          exit 0
        fi

        ${tailscale.package}/bin/tailscale up ${toString tailscale.extraUpFlags}
      '';
    };
  };
}
