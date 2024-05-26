{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.ooknet.host;
in

{
  config = mkIf (host.type != "phone") {
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
