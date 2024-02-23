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
        base.enable = true;
        windowManager.hyprland.enable = true;
        lockscreen.hyprlock.enable = true;
        notification.mako.enable = true;
        bar.ags.enable = true;
      };
      communication = {
        discord.enable = true;
      };
      browser.firefox = {
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
        image.imv.enable = true;
        video = {
          mpv.enable = true;
          youtube.enable = true;
        };
      };
      themeSettings.enable = true;
    };
  };
}
