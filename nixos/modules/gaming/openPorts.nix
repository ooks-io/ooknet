{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.gaming.openPorts;
in

{
  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 3074 ];
      allowedUDPPorts = [
        88
        500
        3074
        2075
        3544
        4500
      ];
    };
  };
}
