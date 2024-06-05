{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf; 
  polkit = config.ooknet.security.polkit;
in

{
  config = {
    systemd.user.services = {
      polkit-pantheon-authentication-agent-1 = mkIf (polkit == "pantheon") {
        Unit.Description = "polkit-pantheon-authentication-agent-1";

        Install = {
          WantedBy = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      polkit-gnome-authentication-agent-1 = mkIf (polkit == "gnome") {
        Unit.Description = "polkit-pantheon-authentication-agent-1";
        Install = {
          WantedBy = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
