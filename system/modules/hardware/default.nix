{ lib, ... }:

{
  imports = [
    ./bluetooth.nix
    ./backlight.nix
    ./power.nix
  ];

  options.systemModules.hardware = {
    bluetooth = {
      enable = lib.mkEnableOption "Enable bluetooth module";
    };
    backlight= {
      enable = lib.mkEnableOption "Enable backlight module";
    };
    power = {
      enable = lib.mkEnableOption "Enable power module";
    };
  };
}
