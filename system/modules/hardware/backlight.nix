{ lib, config, ... }:

let
  cfg = config.systemModules.hardware.backlight;
in

{
  config = lib.mkIf cfg.enable {
    hardware.brillo.enable = true;
  };
}
