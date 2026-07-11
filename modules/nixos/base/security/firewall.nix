{
  networking = {
    # nftables backend: cleaner source-scoped rules (extraInputRules) and
    # unifies with the nftables fail2ban action already in use
    nftables.enable = true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22 # SSH
        80
        443
      ];

      # dont respond to icmpv4 pings.
      allowPing = false;
    };
  };
}
