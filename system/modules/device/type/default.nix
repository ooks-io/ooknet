{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  options.systemModules.device.type = mkOption {
    type = types.enum ["desktop" "server" "phone" "vm"];
    default = "desktop";
    description = "Define what type of device the host is";
  };
}

