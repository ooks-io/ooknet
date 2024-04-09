{ lib, config, pkgs, ... }:

let
  cfg = config.systemModules.security;
in

{
  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      polkit_gnome
    ];

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      _1password = {
        enable = true;
      };
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "ooks" ];
      };
    };
    security = {
      polkit = {
        enable = true;
      };
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
      rtkit.enable = true;
      pam.services.hyprlock = {};
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
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
