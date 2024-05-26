{ lib, config, ... }:

let
  inherit (lib) mkIf;
  host = config.ooknet.host;
in

{
  config = mkIf (host.type != "phone") {
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };
  };
}
