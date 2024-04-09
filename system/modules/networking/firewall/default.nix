{ lib, config, ... }:

let
  cfg = config.systemModules.networking;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.systemModules.networking.firewall = mkEnableOption "Enable networking firewall system modules";
  config = mkIf cfg.firewall {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        443 # https
        57621 # spotify
      ];
    };
  };
}
