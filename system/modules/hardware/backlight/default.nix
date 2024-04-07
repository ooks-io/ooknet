{ lib, config, ... }:

let
  cfg = config.systemModules.hardware.backlight;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.systemModules.hardware.backlight = {
    enable = mkEnableOption "Enable backlight module";
  };
  
  config = mkIf cfg.enable {
    hardware.brillo.enable = true;
  };
}
