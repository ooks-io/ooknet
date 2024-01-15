{ lib, ... }:
{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  networking.firewall.allowedTCPPorts = [57621];

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };
    resolved.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
