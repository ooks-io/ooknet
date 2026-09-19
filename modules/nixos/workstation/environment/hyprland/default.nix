{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (config.ooknet.workstation) environment;
  inherit (config.ooknet.host) admin;

  # hyprland 0.56 warns when not launched through its start-hyprland watchdog,
  # uwsm has a start_hyprland plugin so the binary name is fine as the unit id
  uwsmStart = "${getExe config.programs.uwsm.package} start -D Hyprland -- /run/current-system/sw/bin/start-hyprland";
in {
  config = mkIf (environment == "hyprland") {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # withUWSM only enables uwsm, the session entry still has to be declared
    programs.uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/start-hyprland";
    };

    # autologin straight into the uwsm session, hyprlock is the lock (luks is
    # the boot boundary). tuigreet only shows up after a logout
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        initial_session = {
          command = uwsmStart;
          user = admin.name;
        };
        default_session.command = "${getExe pkgs.tuigreet} --time --remember --asterisks --cmd '${uwsmStart}'";
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
        common = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Screencast" = "hyprland";
          "org.freedesktop.impl.portal.Screenshot" = "hyprland";
        };
      };
    };

    # required for wayland screen lockers to work
    security.pam.services.hyprlock.text = "auth include login";

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
