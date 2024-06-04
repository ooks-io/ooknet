{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.wayland;
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
