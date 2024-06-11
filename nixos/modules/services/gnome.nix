{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.services.gnomeServices; 
in

{
  config = mkIf cfg.enable {
    services = {
      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
      };
      udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
    };
  };
}
