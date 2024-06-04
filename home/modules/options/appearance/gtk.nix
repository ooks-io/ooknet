{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.gtk.enable = mkEnableOption;
}
