{
  lib,
  pkgs,
  config,
  ook,
  ...
}: let
  inherit (lib) mkIf concatMapStringsSep;
  inherit (ook) color;
  inherit (config.ooknet.workstation) environment;
  inherit (config.ooknet.appearance.fonts) monospace;

  aerospace = "/run/current-system/sw/bin/aerospace";
  sketchybar = "${pkgs.sketchybar}/bin/sketchybar";
  # bar-specific size: terminal font pt reads oversized in the slim bar
  font = "${monospace.family}:Regular:13.0";

  # mirrors waybar: workspaces 1-5 always shown, the rest only when occupied
  workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "ai"];

  workspacePlugin = pkgs.writeShellScript "sketchybar-workspace" ''
    ws="''${NAME#space.}"
    focused="''${FOCUSED_WORKSPACE:-$(${aerospace} list-workspaces --focused)}"

    persistent=0
    case "$ws" in
      1 | 2 | 3 | 4 | 5) persistent=1 ;;
    esac

    if [ "$ws" = "$focused" ]; then
      ${sketchybar} --set "$NAME" drawing=on icon=● icon.color=0xff${color.primary.base}
    else
      windows=$(${aerospace} list-windows --workspace "$ws" --count 2>/dev/null || echo 0)
      if [ "$persistent" = 1 ] || [ "''${windows:-0}" -gt 0 ]; then
        ${sketchybar} --set "$NAME" drawing=on icon=○ icon.color=0xff${color.typography.text}
      else
        ${sketchybar} --set "$NAME" drawing=off
      fi
    fi
  '';

  # same thresholds and glyphs as the waybar battery module
  batteryPlugin = pkgs.writeShellScript "sketchybar-battery" ''
    batt="$(pmset -g batt)"
    pct="$(echo "$batt" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
    if [ -z "$pct" ]; then
      ${sketchybar} --set "$NAME" drawing=off
      exit 0
    fi

    icons=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
    idx=$((pct / 10))
    [ "$idx" -gt 9 ] && idx=9
    icon="''${icons[$idx]}"
    echo "$batt" | grep -q 'AC Power' && icon="󱐋$icon"

    clr="0xff${color.typography.text}"
    [ "$pct" -le 35 ] && clr="0xff${color.warning.base}"
    [ "$pct" -le 15 ] && clr="0xff${color.error.base}"

    ${sketchybar} --set "$NAME" drawing=on icon="$icon" icon.color="$clr" label="$pct%"
  '';

  clockPlugin = pkgs.writeShellScript "sketchybar-clock" ''
    ${sketchybar} --set "$NAME" label="$(date '+%I:%M %p')"
  '';
in {
  config = mkIf (environment == "aerospace") {
    services.sketchybar = {
      enable = true;
      config = ''
        sketchybar --bar position=top height=20 y_offset=12 margin=16 \
          padding_left=0 padding_right=0 color=0x00000000

        sketchybar --default \
          icon.font="${font}" \
          label.font="${font}" \
          icon.color=0xff${color.typography.text} \
          label.color=0xff${color.typography.text} \
          background.drawing=off \
          icon.padding_left=8 icon.padding_right=4 \
          label.padding_left=0 label.padding_right=8

        sketchybar --add event aerospace_workspace_change

        sketchybar --add item clock left
        sketchybar --set clock update_freq=30 script="${clockPlugin}" \
          icon.padding_left=0 icon.padding_right=0 label.padding_left=8

        sketchybar --add item battery left
        sketchybar --set battery update_freq=60 script="${batteryPlugin}"
        sketchybar --subscribe battery system_woke power_source_change

        ${concatMapStringsSep "\n" (ws: ''
            sketchybar --add item space.${ws} left
            sketchybar --set space.${ws} icon=○ label.drawing=off \
              icon.padding_left=5 icon.padding_right=5 \
              click_script="${aerospace} workspace ${ws}" \
              script="${workspacePlugin}"
            sketchybar --subscribe space.${ws} aerospace_workspace_change
          '')
          workspaces}

        sketchybar --add bracket bar_group clock battery '/space\..*/'
        sketchybar --set bar_group \
          background.drawing=on \
          background.color=0xff${color.layout.header} \
          background.border_color=0xff${color.border.base} \
          background.border_width=1 \
          background.corner_radius=0 \
          background.height=20

        sketchybar --update
        sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$(${aerospace} list-workspaces --focused)"
      '';
    };

    # keep the workspace indicator in sync with aerospace
    services.aerospace.settings.exec-on-workspace-change = [
      "/bin/bash"
      "-c"
      "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
    ];
  };
}
