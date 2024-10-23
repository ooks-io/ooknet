{
  networking.firewall = {
    enable = true;

    # dont respond to icmpv4 pings.
    allowPing = false;
  };
}
