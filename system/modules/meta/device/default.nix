{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  options.systemModules.meta.device.type = mkOption {
    type = types.enum ["desktop" "server" "phone" "vm"];
    default = "desktop";
    description = "Meta option to describe what type of device the host is";
  };
}
