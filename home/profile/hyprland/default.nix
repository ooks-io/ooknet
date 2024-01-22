{ config, lib, ... }:
let
  cfg = config.profiles.hyprland;
in
{

  imports = [
    ../../programs
  ];
  
  config = lib.mkIf cfg.enable {
    programs.desktop = {
      wayland = {
        base.enable = true;
        windowManager.hyprland.enable = true;
        lockscreen.swaylock.enable = true;
        notification.mako.enable = true;
        bar.eww.enable = true;
      };
      communication = {
        discord.enable = true;
      };
      browser.firefox = {
        enable = true;
        default = true;
      };
      terminal.foot = {
        enable = true;
        default = true;
      };
      themeSettings.enable = true;
    };
  };
}
