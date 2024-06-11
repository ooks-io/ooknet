{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.programs = {
    _1password.enable = mkEnableOption "";
    dconf.enable = mkEnableOption "";
    kdeconnect.enable = mkEnableOption "";
  };
}
