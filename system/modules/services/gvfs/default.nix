{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  config = mkIf ( host.type != "phone") {
    services.gvfs = true;
  };
}
