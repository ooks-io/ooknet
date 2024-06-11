{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.services = {
    nixarr.enable = mkEnableOption "";    
    gnomeServices.enable = mkEnableOption "";
    gvfs.enable = mkEnableOption "";
    dbus.enable = mkEnableOption "";
    system76Scheduler.enable = mkEnableOption "";
    flatpak.enable = mkEnableOption "";
  };
}
