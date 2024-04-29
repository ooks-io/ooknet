{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  host = config.systemModules.host; 
in

{
  config = mkIf (host.type != "phone" && host.type != "server") {
    services = {
      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
      };
      udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
    };
  };
}
