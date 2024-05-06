{ config, lib, pkgs, inputs, ... }:

let
  fonts = config.homeModules.theme.fonts;
  cfg = config.homeModules.desktop.wayland.bar.waybar;
  monitorWidth =  (lib.head config.monitors).width - 20;
  inherit (config.colorscheme) colors;
in

{
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar;

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        width = monitorWidth;
        exclusive = true;
        margin-top = 10;
        margin-bottom = -12;

        modules-left = [ "clock" "battery" "hyprland/workspaces" ];
        modules-center = [];
        modules-right = [ "custom/hyprrecord" "tray" ];

        "hyprland/workspaces" = let
          hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
        in {
          on-click = "activate";
          on-scroll-up = "${hyprctl} dispatch workspace m+1";
          on-scroll-down = "${hyprctl} dispatch workspace m-1";
          format = "{icon}";
          active-only = false;
          persistent-workspaces = {
            "*" = 5;
          };
          format-icons = {
            active = "";
            default = "";
            urgent = "";
          };
          all-outputs = false;
        };

        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%Y-%m-%d}";
        };
        battery = {
          states = {
            good = 100;
            warning = 35;
            critical = 15;
          };
          bat = "BAT0";
          interval = 10;
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format = "{icon} {capacity}%";
          format-charging = "󱐋{icon} {capacity}%";
          tooltip-format = "{timeTo} {power}W";
        };
        tray = {
          icon-size = 21;
          spacing = 5;
        };
        "custom/hyprrecord" = {
          format = "{}";
          interval = "once";
          exec = "echo  ";
          tooltip = "false";
          exec-if = "pgrep wl-screenrec";
          on-click = "exec hyprrecord -a --waybar screen copysave video";
          signal = 12;
        };
      };
      style = /* css */ ''
        * {
          font-family: "${fonts.monospace.family}";
          font-size: 19px;
          border: solid #${colors.base05};
        }

        window#waybar {
          background-color: transparent;
          margin: 10px;
        }

        #clock,
        #battery,
        #workspaces {
          background-color: #${colors.base00};
          padding-right: 10px;
        }

        #clock {
          padding-left: 10px;
          border: 2px solid #${colors.base05};
          border-right: 0px;
          border-top-left-radius: 10px;
        }

        #battery {
          padding-left: 10px;
          border-top: 2px solid #${colors.base05};
          border-bottom: 2px solid #${colors.base05};
          border-left: 0px;
        }

        #battery.good {
          color: #${colors.base0B};
        }
        #battery.warning {
          color: #${colors.base0A};
        }
        #battery.critical {
          color: #${colors.base08};
        }

        #tray {
          padding-right: 10px;
          padding-left: 10px;
          background-color: transparent;
          border: 0;
        }

        #workspaces {
          border: 2px solid #${colors.base05};
          border-left: 0;
          border-top-right-radius: 10px;
        }

        #workspace button,
        #workspaces button.active,
        #workspaces button.visible {
          color: #${colors.base0B};
        }

        #workspaces button.urgent {
          color: #${colors.base08};
        }

        #custom-hyprrecord {
          color: #${colors.base08};
          padding-right: 20px;
        }
      '';
    };
  };
}
