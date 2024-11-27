{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server.media-server) ports transmission;
  inherit (config.age) secrets;
in {
  config = mkIf transmission.enable {
    vpnNamespaces.wg = {
      enable = true;
      wireguardConfigFile = secrets.mullvad_wg.path;
      accessibleFrom = [
        "192.168.0.1/24"
        "127.0.0.1"
        "10.0.0.0/8"
      ];
      openVPNPorts = [
        # Transmission
        {
          port = ports.transmission.peer;
          protocol = "both";
        }
      ];
      portMappings = [
        # Transmission
        {
          from = ports.transmission.web;
          to = ports.transmission.web;
        }
      ];
    };
    systemd.services.transmission.vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };
  };
}
