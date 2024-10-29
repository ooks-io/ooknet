{
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      22 # SSH
      80
      443
    ];

    # dont respond to icmpv4 pings.
    allowPing = false;
  };
}
