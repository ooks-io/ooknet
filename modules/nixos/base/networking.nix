{
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce mkDefault;
  inherit (config.ooknet) host;
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
        # why does my server have wifi? not sure.
        # ensure my mac addr is static so I can reserve an IP
        macAddress =
          if host.role == "server"
          then "permanent"
          else "random";
        scanRandMacAddress = host.role != "server";
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
  # sometimes causes issues with network manager service never actually starting
  # requiring me to manually start the service. fine on a workstation, not on a server
  systemd.services.NetworkManager-wait-online.enable = host.role != "server";
}
