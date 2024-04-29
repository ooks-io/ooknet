{ lib, config, ... }:

let
  features = config.systemModules.host.hardware.features;
  inherit (lib) mkIf;
  inherit (builtins) elem;
in

{
  config = mkIf (elem "backlight" features) {
    hardware.brillo.enable = true;
  };
}
