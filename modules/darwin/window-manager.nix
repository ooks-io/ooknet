{
  hozen,
  pkgs,
  config,
  ...
}: let
  inherit (hozen) color;
  inherit (config.ooknet.appearance.fonts) monospace regular;
  padding = 15;
  mod = "cmd";
in {
  services = {
    aerospace = {
      enable = true;
      settings = {
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        accordion-padding = padding;
        gaps = {
          outer = {
            left = padding;
            right = padding;
            top = padding;
            bottom = padding;
          };
          inner = {
            horizontal = padding;
            vertical = padding;
          };
        };
        mode = {
          main = {
            binding = {
              "${mod}-left" = "focus left --boundaries all-monitors-outer-frame";
              "${mod}-right" = "focus right --boundaries all-monitors-outer-frame";
              "${mod}-up" = "focus up --boundaries all-monitors-outer-frame";
              "${mod}-down" = "focus down --boundaries all-monitors-outer-frame";
              "${mod}-1" = "workspace 1";
              "${mod}-2" = "workspace 2";
              "${mod}-3" = "workspace 3";
              "${mod}-4" = "workspace 4";
              "${mod}-5" = "workspace 5";
              "${mod}-6" = "workspace 6";
              "${mod}-7" = "workspace 7";
              "${mod}-8" = "workspace 8";
              "${mod}-9" = "workspace 9";

              "${mod}-shift-1" = "move-node-to-workspace 1";
              "${mod}-shift-2" = "move-node-to-workspace 2";
              "${mod}-shift-3" = "move-node-to-workspace 3";
              "${mod}-shift-4" = "move-node-to-workspace 4";
              "${mod}-shift-5" = "move-node-to-workspace 5";
              "${mod}-shift-6" = "move-node-to-workspace 6";
              "${mod}-shift-7" = "move-node-to-workspace 7";
              "${mod}-shift-8" = "move-node-to-workspace 8";
              "${mod}-shift-9" = "move-node-to-workspace 9";

              "alt-enter" = "exec-and-forget osascript ${pkgs.writeText "open-ghostty.applescript" ''
                tell application "Ghostty"
                  if it is running then
                    activate
                    tell application "System Events" to keystroke "n" using {command down}
                  else
                    activate
                  end if
                end tell
              ''}";
            };
          };
        };
      };
    };
    sketchybar = {
      enable = true;
      config = ''
        bar_config=(
          color="${color.layout.header}"
          height=40
          margin=${toString padding}
          position=top
          sticky=on
          corner_radius=8
        )
      '';
    };
    jankyborders = {
      enable = true;
      order = "above";
      active_color = "0xff${color.border.active}";
      inactive_color = "0xff${color.border.inactive}";
      width = 5.0;
    };
  };
  fonts.packages = [
    monospace.package
    regular.package
  ];
}
