{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf types mkOption; 
  inherit (builtins) elem;
  cfg = config.homeModules.security.polkit;
in

{
  options.homeModules.security.polkit = mkOption {
    type = types.enum ["gnome" "pantheon"]; # TODO: add kde agent
    default = "";
    description = "Type of polkit agent module to use";
  };

  config = {
    systemd.user.services = {
      polkit-pantheon-authentication-agent-1 = mkIf (elem cfg ["pantheon"]) {
        description = "polkit-pantheon-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      polkit-gnome-authentication-agent-1 = mkIf (elem cfg ["gnome"]) {
        description = "polkit-pantheon-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
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
