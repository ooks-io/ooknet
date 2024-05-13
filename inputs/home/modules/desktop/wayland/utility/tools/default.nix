{ lib, config, pkgs, ... }:

let
  cfg = config.homeModules.desktop.wayland.utility.tools;
in

{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim
        slurp
        libnotify
        wl-screenrec
        wf-recorder
        wl-clipboard
      ];
    };
    
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
