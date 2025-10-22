{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (builtins) attrValues;
  inherit (config.ooknet.workstation) environment;
in {
  config = mkIf (environment == "gnome") {
    services = {
      xserver.enable = true;
      displayManager.gdm = {
        enable = true;
      };
      desktopManager.gnome = {
        enable = true;
      };
    };
    programs.ssh.startAgent = mkForce false;
    environment.gnome.excludePackages = attrValues {
      inherit
        (pkgs)
        orca
        epiphany
        evince
        gedit
        gnome-music
        gnome-photos
        gnome-terminal
        gnome-tour
        hitori
        iagno
        tali
        atomix
        ;
    };
  };
}
