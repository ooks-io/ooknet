{
  lib,
  pkgs,
  osConfig,
  hozen,
  ...
}: let
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (hozen) color;
  inherit (osConfig.ooknet.hardware) monitors;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (lib) mkIf head elem;

  primaryMonitor = head monitors;

  isVertical = elem primaryMonitor.transform [1 3];
  width =
    if isVertical
    then primaryMonitor.height - 20
    else primaryMonitor.width - 20;
in {
  config = mkIf (environment == "hyprland") {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar;

      settings.mainBar = {
        inherit width;
        layer = "top";
        position = "top";
        height = 32;
        exclusive = true;
        margin-top = 10;
        margin-bottom = -12;

        modules-left = ["clock" "battery" "hyprland/workspaces"];
        modules-center = [];
        modules-right = ["custom/hyprrecord" "tray"];

        "hyprland/workspaces" = let
          hyprctl = osConfig.programs.hyprland.package + "/bin/hyprctl";
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
          format-alt = "{:%d-%m-%Y}";
        };
        battery = {
          states = {
            good = 100;
            warning = 35;
            critical = 15;
          };
          bat = "BAT0";
          interval = 10;
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
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
      style =
        /*
        css
        */
        ''
          * {
            font-family: "${fonts.monospace.family}";
            font-size: ${toString fonts.monospace.size}px;
            border: solid #${color.border.base};
          }

          window#waybar {
            background-color: transparent;
            margin: 10px;
          }

          #clock,
          #battery,
          #workspaces {
            background-color: #${color.layout.header};
            padding-right: 10px;
          }

          #clock {
            padding-left: 10px;
            border: 2px solid #${color.border.base};
            border-right: 0px;
            border-top-left-radius: 10px;
          }

          #battery {
            padding-left: 10px;
            border-top: 2px solid #${color.border.base};
            border-bottom: 2px solid #${color.border.base};
            border-left: 0px;
          }

          #battery.good {
            color: #${color.success.base};
          }
          #battery.warning {
            color: #${color.warning.base};
          }
          #battery.critical {
            color: #${color.error.base};
          }

          #tray {
            padding-right: 10px;
            padding-left: 10px;
            background-color: transparent;
            border: 0;
          }

          #workspaces {
            border: 2px solid #${color.border.base};
            border-left: 0;
            border-top-right-radius: 10px;
          }

          #workspace button,
          #workspaces button.active,
          #workspaces button.visible {
            color: #${color.primary.base};
          }

          #workspaces button.urgent {
            color: #${color.orange.base};
          }

          #custom-hyprrecord {
            color: #${color.red.base};
            padding-right: 20px;
          }
        '';
    };
  };
}
