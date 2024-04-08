{ lib, config, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./bluetooth
    ./backlight
    ./battery
  ];

  options.systemModules.hardware.features = mkOption {
    type = with types; listOf (enum ["bluetooth" "backlight" "battery"]);
    default = [];
    description = "What extra hardware feature system modules to use";
  };
}
