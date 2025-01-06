{
  inputs',
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep getExe mkIf;
  inherit (config.ooknet.workstation) environment;
  inherit (inputs'.hyprland.packages) xdg-desktop-portal-hyprland hyprland;
in {
  config = mkIf (environment == "hyprland") {
    programs.hyprland = {
      enable = true;
      package = hyprland;
      portalPackage = xdg-desktop-portal-hyprland;
      withUWSM = false; #TODO
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      config.common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Screencast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
      };
    };

    # required for wayland screen lockers to work
    security.pam.services.hyprlock.text = "auth include login";

    services.greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = concatStringsSep " " [
            (getExe pkgs.greetd.tuigreet)
            "--time"
            "--remember"
            "--cmd"
            "Hyprland"
          ];
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
