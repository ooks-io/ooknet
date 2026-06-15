{
  lib,
  ook,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) int bool str listOf attrsOf submodule;
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
  mkBool = default:
    mkOption {
      type = bool;
      inherit default;
    };
  service = submodule {
    options = {
      name = mkStr "";
      http = mkStr ""; # direct: url to GET
      bodyContains = mkStr ""; # http only
      ssh = mkStr ""; # ssh check: host to curl localhost on (for proxied/vpn'd services)
      port = mkInt 0; # localhost port for the ssh check
      path = mkStr ""; # url path, default /
      expect = mkInt 0; # expected status, 0 = any 2xx/3xx
      degradedMs = mkInt 0; # latency over this -> degraded
    };
  };
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
      compact = mkBool true; # collapse to a chevron, reveal icons on hover
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

    monitor = {
      width = mkInt 380; # dashboard pane width
      services = mkOption {
        type = listOf service;
        # ookflix stack on ooksmedia is behind traefik/gluetun, so checked via ssh
        # (curl localhost on the host) rather than directly
        default = [
          {
            name = "website";
            http = "https://www.ooknet.org";
          }
          {
            name = "plex";
            ssh = "ooksmedia";
            port = 32400;
            path = "/identity";
          }
          {
            name = "jellyfin";
            ssh = "ooksmedia";
            port = 8096;
          }
          {
            name = "sonarr";
            ssh = "ooksmedia";
            port = 8989;
          }
          {
            name = "radarr";
            ssh = "ooksmedia";
            port = 7878;
          }
          {
            name = "prowlarr";
            ssh = "ooksmedia";
            port = 9696;
          }
          {
            name = "jellyseerr";
            ssh = "ooksmedia";
            port = 5055;
          }
          {
            name = "tautulli";
            ssh = "ooksmedia";
            port = 8181;
          }
          {
            name = "homepage";
            ssh = "ooksmedia";
            port = 3000;
          }
          {
            name = "qbittorrent";
            ssh = "ooksmedia";
            port = 8081;
          }
        ];
      };
      qbittorrent = {
        enable = mkBool true;
        service = mkStr "qbittorrent"; # which service entry to enrich
        ssh = mkStr "ooksmedia";
        container = mkStr "qbittorrent"; # podman container (queried via podman exec, no auth)
        port = mkInt 8080; # webui port inside the container
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

      # per-app overrides keyed by appName (lowercased). lets chat apps that ship
      # avatars + channel context render with their brand color and a clean layout
      apps = mkOption {
        type = attrsOf (submodule {
          options = {
            border = mkColor ""; # border color, empty -> urgency color
            titleFromName = mkBool false; # header = sender name parsed from summary
            hideImage = mkBool false; # ignore the notification image (avatars)
          };
        });
        default = {
          vesktop = {
            border = "#5865F2"; # discord blurple
            titleFromName = true;
            hideImage = true;
          };
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
