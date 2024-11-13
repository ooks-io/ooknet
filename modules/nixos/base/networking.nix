{lib, ...}: let
  inherit (lib) mkForce mkDefault;
in {
  networking = {
    enableIPv6 = true;
    # disable global dhcp
    useDHCP = mkForce false;
    usePredictableInterfaceNames = mkDefault true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = mkForce [];
      wifi = {
        macAddress = "random";
        scanRandMacAddress = true;
        powersave = true;
      };
      unmanaged = ["interface-name:tailscale*"];
    };
  };
  services = {
    resolved = {
      enable = true;

      domains = ["~."];
      fallbackDns = ["8.8.8.8"]; # google dns
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
