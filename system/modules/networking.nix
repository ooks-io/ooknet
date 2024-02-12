{ lib, config, ... }:

let
  cfg = config.systemModules.networking;
in

{
  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    networking.firewall.allowedTCPPorts = [57621]; # Spotify

    services = {
      openssh = {
        enable = true;
        settings.UseDns = true;
      };
      resolved.enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  };
}
