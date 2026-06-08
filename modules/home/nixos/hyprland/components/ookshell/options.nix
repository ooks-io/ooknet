{
  lib,
  ook,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) int bool str listOf;
  inherit (ook) color;
  mkInt = default:
    mkOption {
      type = int;
      inherit default;
    };
  mkColor = default:
    mkOption {
      type = str;
      inherit default;
    };
  mkStr = mkColor;
in {
  options.ooknet.ookshell = {
    enable = mkOption {
      type = bool;
      default = true;
    };

    bar = {
      height = mkInt 32;
      radius = mkInt 10;
      spacing = mkInt 12; # gap between modules in a cluster
      padding = mkInt 12; # inner horizontal padding of a cluster
      borderWidth = mkInt 2;
      margin = {
        top = mkInt 10;
        left = mkInt 10;
        right = mkInt 10;
      };
    };

    workspaces = {
      persistent = mkInt 5; # always-shown count, extras appear dynamically
      spacing = mkInt 10;
    };

    tray = {
      iconSize = mkInt 21;
      spacing = mkInt 8;
      menu = {
        padding = mkInt 6;
        timeout = mkInt 1500; # ms before auto-closing when not hovered
        colors = {
          background = mkColor "#${color.layout.menu}";
          text = mkColor "#${color.typography.text}";
          disabled = mkColor "#${color.typography.subtext}";
          hover = mkColor "#${color.layout.selection}";
        };
      };
    };

    # color roles, defaulting from the active ook scheme. override per-host
    colors = {
      background = mkColor "#${color.layout.header}";
      border = mkColor "#${color.border.base}";
      text = mkColor "#${color.typography.text}";
      workspaceActive = mkColor "#${color.primary.base}";
      workspaceUrgent = mkColor "#${color.orange.base}";
      record = mkColor "#${color.red.base}";
      battery = {
        good = mkColor "#${color.success.base}";
        warning = mkColor "#${color.warning.base}";
        critical = mkColor "#${color.error.base}";
      };
    };

    # terminal-style notification popups (replaces mako)
    notifications = {
      columns = mkInt 38; # card width in monospace columns
      padding = mkInt 8; # inner px padding between frame and text
      # command (as args list) to open a screenshot for editing on click; the
      # image path is appended. empty -> default (satty) resolved in default.nix
      imageEditor = mkOption {
        type = listOf str;
        default = [];
      };
      maxBodyLines = mkInt 4;
      maxVisible = mkInt 5;
      spacing = mkInt 8; # gap between stacked cards
      margin = {
        top = mkInt 10;
        right = mkInt 10;
      };
      timeout = {
        # ms, 0 = sticky (no auto-dismiss)
        low = mkInt 3000;
        normal = mkInt 3000;
        critical = mkInt 0;
      };
      glyphs = {
        topLeft = mkStr "┌";
        topRight = mkStr "┐";
        bottomLeft = mkStr "└";
        bottomRight = mkStr "┘";
        horizontal = mkStr "─";
        vertical = mkStr "│";
      };
      colors = {
        background = mkColor "#${color.layout.menu}";
        title = mkColor "#${color.typography.text}";
        text = mkColor "#${color.typography.text}";
        action = mkColor "#${color.primary.base}";
        # border colors, normal matches hyprland's col.active_border
        urgency = {
          low = mkColor "#${color.neutrals."650"}";
          normal = mkColor "#${color.neutrals."650"}";
          critical = mkColor "#${color.red.base}";
        };
      };
    };

    # ascii cells on-screen display for volume / brightness / mic
    osd = {
      cells = mkInt 24; # number of slider cells
      timeout = mkInt 1500; # ms visible after a change
      padding = mkInt 8;
      # marginTop is derived in default.nix: aligned to the bar's bottom edge so
      # the osd's top border is inline with where windows start
      glyphs = {
        filled = mkStr "▮";
        empty = mkStr "▯";
      };
      colors = {
        border = mkColor "#${color.neutrals."650"}";
        title = mkColor "#${color.typography.text}";
        filled = mkColor "#${color.primary.base}";
        empty = mkColor "#${color.neutrals."600"}";
        text = mkColor "#${color.typography.text}";
        muted = mkColor "#${color.red.base}";
      };
    };
  };
}
