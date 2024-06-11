{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.gaming = {
    steam.enable = mkEnableOption "";
    gamescope.enable = mkEnableOption "";
    gamemode.enable = mkEnableOption "";
    openPorts.enable = mkEnableOption "";
  };
}
