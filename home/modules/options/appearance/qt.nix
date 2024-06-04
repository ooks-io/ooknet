{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.qt.enable = mkEnableOption "";
}
