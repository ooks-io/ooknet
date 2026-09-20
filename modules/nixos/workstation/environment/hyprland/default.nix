{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce getExe;
  inherit (config.ooknet.workstation) environment;
  inherit (config.ooknet.host) admin;

  # hyprland 0.56 warns when not launched through its start-hyprland watchdog,
  # uwsm has a start_hyprland plugin so the binary name is fine as the unit id
  # -g -1: dont wait for graphical.target, this unit is part of it and any slow
  # multi-user unit would otherwise delay the lock screen.
  # --locked-cmd: hyprland comes up with the session already locked at the
  # protocol level and spawns the locker itself, so binds and input never reach
  # the autologin session before hyprlock has it
  uwsmStart = "${getExe config.programs.uwsm.package} start -g -1 -D Hyprland -- /run/current-system/sw/bin/start-hyprland -- --locked-cmd ${getExe pkgs.hyprlock}";

  plymouth = getExe' config.boot.plymouth.package "plymouth";
  hyprctl = getExe' config.programs.hyprland.package "hyprctl";
  inherit (lib) getExe';

  # plymouth must outlive hyprlands first modeset: while its drm fd is open
  # the kernel keeps scanning out its last frame, once hyprland is master and
  # has committed its own buffer the quit is invisible. quitting earlier makes
  # the kernel restore the (black) fbdev buffer
  quitPlymouthOnceUp = pkgs.writeShellScript "quit-plymouth-once-up" ''
    uid=$(id -u ${admin.name})
    export XDG_RUNTIME_DIR=/run/user/$uid
    for _ in $(seq 1 150); do
      for d in "$XDG_RUNTIME_DIR"/hypr/*/; do
        sig=$(basename "$d")
        if ${hyprctl} -i "$sig" monitors >/dev/null 2>&1; then
          exec ${plymouth} quit --retain-splash
        fi
      done
      sleep 0.1
    done
    ${plymouth} quit --retain-splash
  '';

  # omarchy-style login on tty1, no display manager. greetd (and any other dm)
  # clears the vt in text mode right before exec, which is the console flash
  # between plymouth and the compositor. this keeps the vt in graphics mode so
  # nothing paints between plymouths retained frame and hyprlands first one
  seamlessLogin = pkgs.writeCBin "seamless-login" ''
    #include <fcntl.h>
    #include <linux/kd.h>
    #include <linux/vt.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/ioctl.h>
    #include <unistd.h>

    int main(int argc, char *argv[]) {
      if (argc < 2) {
        fprintf(stderr, "usage: %s <session command...>\n", argv[0]);
        return 1;
      }

      int fd = open("/dev/tty1", O_RDWR);
      if (fd < 0) fd = 0; // systemd already gave us the tty as stdin

      if (ioctl(fd, VT_ACTIVATE, 1) < 0) perror("VT_ACTIVATE");
      if (ioctl(fd, VT_WAITACTIVE, 1) < 0) perror("VT_WAITACTIVE");
      // graphics mode, fbcon must never paint between plymouth and hyprland
      if (ioctl(fd, KDSETMODE, KD_GRAPHICS) < 0) perror("KDSETMODE");
      const char *clear = "\033[H\033[2J";
      if (write(fd, clear, strlen(clear)) < 0) perror("clear");
      if (fd != 0) close(fd);

      const char *home = getenv("HOME");
      if (home && chdir(home) < 0) perror("chdir");

      execvp(argv[1], &argv[1]);
      perror("exec");
      return 1;
    }
  '';
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
    # the boot boundary). logout just relaunches, so there is no greeter
    systemd.services.seamless-login = {
      description = "seamless autologin into hyprland on tty1";
      wantedBy = ["graphical.target"];
      conflicts = ["getty@tty1.service" "plymouth-quit.service"];
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "systemd-logind.service"
        "plymouth-start.service"
      ];
      # if the session keeps dying, drop the splash and give a login prompt
      # instead of a dead graphics-mode vt
      onFailure = ["plymouth-quit.service" "getty@tty1.service"];
      # no PartOf=graphical.target: nixos-rebuild restarts every active target
      # on switch and PartOf would take the session down with it
      unitConfig = {
        StartLimitIntervalSec = 60;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        # plymouthd only talks to root, so none of this can live in the
        # user-owned helper. deactivate drops drm master and keeps the frame,
        # the post hook quits once hyprland is up. "-" ignores a missing
        # plymouthd (relaunch after logout), "+" runs as root despite User=
        ExecStartPre = "-+${plymouth} deactivate";
        ExecStartPost = "-+${quitPlymouthOnceUp}";
        ExecStart = "${getExe seamlessLogin} ${uwsmStart}";
        User = admin.name;
        PAMName = "login";
        TTYPath = "/dev/tty1";
        # systemd would flip the vt back to text mode on reset/disallocate
        TTYReset = false;
        TTYVHangup = true;
        TTYVTDisallocate = false;
        StandardInput = "tty";
        StandardOutput = "journal";
        StandardError = "journal";
        Restart = "always";
        RestartSec = 2;
        TimeoutStopSec = 20;
      };
      # dont take the session down on nixos-rebuild switch
      restartIfChanged = false;
      stopIfChanged = false;
    };

    # getty.target wants autovt@tty1 and nixos-rebuild starts every active target
    # on switch, so the conflict would stop this unit each time. same fix the
    # greetd module uses. getty@tty1 itself stays available for OnFailure
    systemd.services."autovt@tty1".enable = false;

    # shutdown waited the full 90s default on an app scope whose zellij server
    # ignores SIGTERM, uwsm then sat waiting for the compositor unit
    systemd.user.settings.Manager.DefaultTimeoutStopSec = "10s";

    # plymouth stays up until the login unit quits it. same trick the gdm module
    # uses, otherwise multi-user.target would kill it early (and plymouth-quit
    # conflicts with the login unit)
    systemd.services.plymouth-quit.wantedBy = mkIf config.boot.plymouth.enable (mkForce []);
    systemd.services.plymouth-quit-wait.wantedBy = mkIf config.boot.plymouth.enable (mkForce []);

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
