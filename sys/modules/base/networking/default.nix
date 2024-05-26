{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  imports = [
    ./firewall.nix
    ./tools.nix
    ./ssh.nix
    ./tcp.nix
    ./resolved.nix
    ./tailscale.nix
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
