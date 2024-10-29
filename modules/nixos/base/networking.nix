{lib, ...}: let
  inherit (lib) mkForce mkDefault;
in {
  networking = {
    enableIPv6 = true;
    # disable global dhcp
    useDHCP = mkForce false;
    usePredictableInterfaceNames = mkDefault true;
    nameservers = [
      #quad9 IPv6
      "2620:fe::fe"
      "2620:fe::9"

      #quad9 IPv4
      "9.9.9.9"
      "149.112.112.112"
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
      fallbackDns = ["9.9.9.9"]; #quad9
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
