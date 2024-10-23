{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.workstation) environment;
in {
  config = mkIf (environment == "hyprland") {
    systemd.user.services = {
      polkit-pantheon-authentication-agent-1 = {
        Unit.Description = "polkit-pantheon-authentication-agent-1";

        Install = {
          WantedBy = ["graphical-session.target"];
          Wants = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
