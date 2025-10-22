{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) role;
in {
  # Enable node_exporter on all servers for Prometheus scraping
  config = mkIf (role == "server") {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = ["systemd"];
      port = 9100;
    };

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [9100];
  };
}
