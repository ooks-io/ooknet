{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.host.networking.tailscale;
  inherit (config.services) tailscale;
  inherit (lib.lists) optionals;
  inherit (lib.strings) concatStringsSep;
  inherit (lib) mkIf mkDefault;
in

{
  config = mkIf cfg.enable {

    services.tailscale = {
      enable = true;
      useRoutingFeatures = mkDefault "both";
      # permitCertUid = "root";
      extraUpFlags = 
        [ "--ssh" "--operator=$USER" ]
        ++ optionals cfg.server [ "--advertise-exit-node" ]
        ++ optionals (cfg.tags != []) ["--advertise-tags" (concatStringsSep "," cfg.tags)]; 
    };

    networking.firewall = {
      allowedUDPPorts = [tailscale.port];
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";
    };

    systemd.network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];

    environment.systemPackages = [ pkgs.tailscale ];
  };
}
