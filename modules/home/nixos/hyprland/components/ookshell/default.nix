{
  lib,
  pkgs,
  config,
  osConfig,
  ook,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (ook) color;
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (osConfig.ooknet.workstation) environment;
  cfg = config.ooknet.ookshell;

  # pull window gaps/border/shadow straight from hyprland so the bar sits flush
  # and notifications wear the same frame as windows
  hyprSettings = config.wayland.windowManager.hyprland.settings;
  hyprGeneral = hyprSettings.general or {};
  hyprDeco = hyprSettings.decoration or {};
  hyprShadow = hyprDeco.shadow or {};
  shadowOffset = lib.splitString " " (toString (hyprShadow.offset or "2 2"));
  gapsOut = hyprGeneral.gaps_out or 10;
  borderSize = hyprGeneral.border_size or 2;

  # editor launched when a screenshot notification is clicked (absolute path so
  # it resolves regardless of the systemd service PATH)
  imageEditor =
    if cfg.notifications.imageEditor != []
    then cfg.notifications.imageEditor
    else ["${pkgs.satty}/bin/satty" "-f"];

  # append-only notification log -> ~/.local/state/ookshell/notifications.jsonl
  # one json line per notification, for later categorization / per-type styling
  notifyLog = pkgs.writeShellApplication {
    name = "ooknotify-log";
    runtimeInputs = [pkgs.jq pkgs.coreutils];
    text = ''
      # ooknotify-log APP SUMMARY BODY URGENCY ICON DESKTOP
      dir="''${XDG_STATE_HOME:-$HOME/.local/state}/ookshell"
      mkdir -p "$dir"
      jq -nc \
        --arg app "''${1:-}" --arg summary "''${2:-}" --arg body "''${3:-}" \
        --arg urgency "''${4:-}" --arg icon "''${5:-}" --arg desktop "''${6:-}" \
        '{ts: (now|todateiso8601), app: $app, summary: $summary, body: $body,
          urgency: $urgency, icon: $icon, desktop: $desktop}' \
        >> "$dir/notifications.jsonl"
    '';
  };

  notifFrame = {
    borderWidth = borderSize;
    rounding = hyprDeco.rounding or 0;
    border = "#${color.neutrals."650"}"; # matches hyprland col.active_border
    shadow = {
      enabled = hyprShadow.enabled or false;
      size = hyprShadow.range or 0;
      offsetX = lib.toInt (builtins.elemAt shadowOffset 0);
      offsetY = lib.toInt (builtins.elemAt shadowOffset 1);
      color = "#${color.neutrals."850"}";
    };
  };
  # window top = margin.top + exclusiveZone + gaps_out + border; bar bottom =
  # margin.top + height. flush -> exclusiveZone = height - gaps_out - border
  exclusiveZone = let
    z = cfg.bar.height - gapsOut - borderSize;
  in
    if z < 0
    then 0
    else z;

  # services to health-check + qbittorrent enrichment (engine reads via --config)
  monitorConfig = pkgs.writeText "ooknet-monitor-config.json" (builtins.toJSON ({
      inherit (cfg.monitor) services;
    }
    // lib.optionalAttrs cfg.monitor.qbittorrent.enable {
      qbittorrent = {
        inherit (cfg.monitor.qbittorrent) service ssh container port;
      };
    }));

  settings = {
    font = {inherit (fonts.monospace) family size;};
    bar = {
      inherit (cfg.bar) height radius spacing padding borderWidth;
      margin = {inherit (cfg.bar.margin) top left right;};
      inherit exclusiveZone;
    };
    workspaces = {inherit (cfg.workspaces) persistent spacing;};
    tray = cfg.tray;
    audio.pwMetadata = lib.getExe' pkgs.pipewire "pw-metadata";
    monitor = {
      cmd = lib.getExe inputs'.ooknet-monitor.packages.default;
      config = "${monitorConfig}";
      notifyCmd = lib.getExe' pkgs.libnotify "notify-send";
      inherit (cfg.monitor) width;
      gap = gapsOut; # align the pane with hyprland window gaps
    };
    colors = cfg.colors;
    frame = notifFrame; # shared hyprland-style window frame (notifications + osd)
    notifications =
      cfg.notifications
      // {
        frame = notifFrame;
        imageEditor = imageEditor;
        logCmd = "${notifyLog}/bin/ooknotify-log";
        logPath = "${config.xdg.stateHome}/ookshell/notifications.jsonl";
      };
    # overlay-layer margins are measured from the bar's reserved edge, not the
    # screen top. windows start gaps_out below that edge, so matching gaps_out
    # puts the osd's top border inline with the window borders
    osd = cfg.osd // {marginTop = gapsOut;};
  };

  configFile = pkgs.writeText "ookshell-config.json" (builtins.toJSON settings);

  configDir = pkgs.runCommandLocal "ookshell" {} ''
    mkdir -p $out
    cp ${./config}/*.qml $out/
    cp ${configFile} $out/config.json
  '';
in {
  imports = [./options.nix];

  config = mkIf (environment == "hyprland" && cfg.enable) {
    home.packages = [pkgs.quickshell];

    xdg.configFile."quickshell/ookshell".source = configDir;

    systemd.user.services.ookshell = {
      Unit = {
        Description = "ookshell bar";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        # point at the config store path (not -c ookshell) so ExecStart changes
        # on every rebuild -> sd-switch restarts the daemon and picks up changes
        ExecStart = "${pkgs.quickshell}/bin/qs -p ${configDir}";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}
