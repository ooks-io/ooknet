{ lib, config, pkgs, ... }:

let
  cfg = config.homeModules.desktop.wayland.base;
in

{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim
        gtk3
        libnotify
        waypipe
        pulseaudio
        pamixer
        slurp
        wf-recorder
        wl-clipboard
        wl-mirror
        xdg-utils
        wlr-randr
      ];
      sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };
    };
    
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
    
    # services.gammastep = {
    #   enable = true;
    #   provider = "geoclue2";
    #   temperature = {
    #     day = 6000;
    #     night = 4600;
    #   };
    #   settings = {
    #     general.adjustment-method = "wayland";
    #   };
    # };
  };
}
