{ lib, config, ... }:

let
  cfg = config.systemModules.networking;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.systemModules.networking.resolved = mkEnableOption "Enable systemd resolved daemon";

  config = mkIf cfg.resolved {
    services.resolved = {
      enable = true;
      fallbackDns = ["9.9.9.9"];
      # allow-downgrade is vulnerable to downgrade attacks
      extraConfig = ''
         DNSOverTLS=yes # or allow-downgrade
      '';
    };
  };
}
