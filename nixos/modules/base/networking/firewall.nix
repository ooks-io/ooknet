{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) host;
in {
  config = mkIf (host.type != "phone") {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        443 # https
        57621 # spotify
      ];
    };
  };
}
