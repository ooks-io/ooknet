{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  host = osConfig.ooknet.host;
in

{
  config = mkIf (elem "workstation" host.function) {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
