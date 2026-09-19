{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "3dprinting" profiles) {
    networking.firewall = {
      # ssdp discovery for lan mode, printers announce on these
      # https://github.com/NixOS/nixpkgs/issues/355821
      allowedUDPPorts = [1990 2021];

      # the announce itself is multicast and nftables drops it by default, so
      # the ports alone arent enough. orca just reports a bad access code.
      # broad on purpose, scope to an iface if it ever matters
      extraInputRules = ''
        meta pkttype multicast accept
      '';
    };
  };
}
