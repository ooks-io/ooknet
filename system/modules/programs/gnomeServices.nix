{ config, lib, pkgs, ... }:

let
  cfg = config.systemModules.programs.gnomeServices;
in

{
  config = lib.mkIf cfg.enable {
     services = {
      dbus.packages = with pkgs; [
        gcr
        gnome.gnome-settings-daemon
      ];
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
    };
  };
}
