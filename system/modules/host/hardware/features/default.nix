{ lib, config, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./bluetooth
    ./backlight
    ./battery
    ./ssd
  ];

  options.systemModules.host.hardware.features = mkOption {
    type = with types; listOf (enum ["bluetooth" "backlight" "battery" "ssd"]);
    default = [];
    description = "What extra hardware feature system modules to use";
  };
}
