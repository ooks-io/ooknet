{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.homeModules.desktop.wayland.lockscreen.hyprlock;
  fonts = config.homeModules.theme.fonts;
  inherit (config.colorscheme) colors;
in

{
  imports = [ 
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    home.sessionVariables.LOCKER = "hyprlock";
    programs.hyprlock = {
      enable = true;
      general = {
        hide_cursor = true;
        no_fade_in = true;
      };
      backgrounds = [
        {
          monitor = "";
          path = "";
          color = "0xff${colors.base01}";
        }
      ];
      input-fields = [
        {
          size = {
            width = 300;
            height = 40;
          };      
          position = {
            x = 0;
            y = 0;
          };
          outline_thickness = 2;
          dots_spacing = 0.2;
          fade_on_empty = false;
          placeholder_text = "";
          outer_color = "0xff${colors.base02}";
          inner_color = "0xff${colors.base00}";
          font_color = "0xff${colors.base05}";
        }
      ];
      labels = [
        {
          monitor = "";
          text = "  ";
          position = {
            x = 0;
            y = 80; 
          };
          color = "0xff${colors.base08}";
          font_size = 30;
          font_family = "${fonts.monospace.family}";
        }
        {
          monitor = "";
          text = "$TIME";
          position = {
            x = 0;
            y = -80; 
          };
          color = "0xff${colors.base0B}";
          font_size = 20;
          font_family = "${fonts.monospace.family}";
        }
      ];
    };
    services.hypridle = {
      enable = true;
      package = pkgs.hypridle;
      beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
      lockCmd = lib.getExe config.programs.hyprlock.package;

      listeners = [
        {
          timeout = 500;
          onTimeout = lib.getExe config.programs.hyprlock.package;
        }
      ];
    };
  };
}
