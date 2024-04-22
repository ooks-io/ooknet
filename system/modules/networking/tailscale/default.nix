{ lib, config, pkgs, ... }:

let
  cfg = config.systemModules.networking.tailscale;
  inherit (config.services) tailscale;
  inherit (lib.lists) optionals;
  inherit (lib.types) bool listOf str; 
  inherit (lib.strings) concatStringsSep;
  inherit (lib) mkIf mkEnableOption mkOption mkDefault;
in

{
  options.systemModules.networking.tailscale = {
    enable = mkEnableOption "Enable tailscale system module";
    server = mkOption {
      type = bool;
      default = false;
      description = "Define if the host is a server";
    };
    client = mkOption {
      type = bool;
      default = cfg.enable;
      description = "Define if the host is a client";
    };
    tag = mkOption {
      type = listOf str;
      default = 
        if cfg.client then ["tag:client"]
        else if cfg.server then ["tag:server"]
        else [];
      description = "Sets host tag depending on if server/client";
    };
    operator = mkOption {
      type = str;
      default = "ooks";
      description = "Name of the tailscale operator";
    };
  };
  
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
