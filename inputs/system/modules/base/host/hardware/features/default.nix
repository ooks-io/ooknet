{ lib, config, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./bluetooth.nix
    ./backlight.nix
    ./battery.nix
    ./ssd.nix
    ./audio.nix
    ./video.nix
  ];

  options.systemModules.host.hardware.features = mkOption {
    type = with types; listOf (enum ["audio" "video" "bluetooth" "backlight" "battery" "ssd"]);
    default = [];
    description = "What extra hardware feature system modules to use";
  };
}
