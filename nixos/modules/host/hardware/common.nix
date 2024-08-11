{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) host;
in {
  config = mkIf (host.type != "phone") {
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };
  };
}
