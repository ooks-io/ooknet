{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  options.systemModules.device.function = mkOption {
    type = with types; listOf (enum ["workstation" "media server" "gaming"]);
    default = [];
    description = "Primary function/s of the device";
  };
}
