{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server.media-server) ports transmission;
  inherit (config.age) secrets;
  inherit (builtins) attrValues;
in {
  config = mkIf transmission.enable {
    environment.systemPackages = attrValues {
      inherit (pkgs) wireguard-tools dnsutils;
    };
    vpnNamespaces.wg = {
      enable = true;
      wireguardConfigFile = secrets."mullvad_wg.conf".path;
      accessibleFrom = [
        "192.168.20.0/24"
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
    systemd.services.wg = {
      serviceConfig = {
        LogLevelMax = "debug";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
