{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  imports = [
    ./firewall
    ./tools
    ./ssh
    ./tcp
    ./resolved
    ./tailscale
  ];

  config = mkIf (host.type != "phone") {
    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    systemd = {
      network.wait-online.enable = false;
      services.NetworkManager-wait-online.enable = false;
    };
  };
}
