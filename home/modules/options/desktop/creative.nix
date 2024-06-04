{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.creative = {
    inkscape.enable = mkEnableOption "";
    audacity.enable = mkEnableOption "";
  };
}
