{ config, lib, ... }:
let
  cfg = config.profiles.hyprland;
in
{

  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    homeModules.desktop = {

      wayland = {
        enable = true;
        windowManager.hyprland = {
          enable = true;
          extras = {
            hyprcapture.enable = true;
            hyprshade.enable = true;
          };
        };
        lockscreen.hyprlock.enable = true;
        notification.mako.enable = true;
        bar.waybar.enable = true;
        launcher.rofi.enable = true;
        utility = {
          tools.enable = true;
          gammastep.enable = true;
        };
      };

      communication = {
        discord.enable = true;
      };

      creative = {
        audio = {
          audacity.enable = true;
        };
      };

      browser.firefox= {
        enable = true;
        default = true;
      };

      terminal = {
        foot = {
          enable = true;
          default = true;
        };
      };

      media = {
        music.tui.enable = true;
        music.easyeffects.enable = true;
        image.imv.enable = true;
        video = {
          mpv.enable = true;
          youtube.enable = true;
          jellyfin.enable = true;
        };
      };
    };
  };
}
