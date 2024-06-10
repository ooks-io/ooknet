{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.gaming = {
    factorio.enable = mkEnableOption "";
    bottles.enable = mkEnableOption "";
    lutris.enable = mkEnableOption "";
  };
}
