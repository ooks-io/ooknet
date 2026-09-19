{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) optionalAttrs;
  inherit (osConfig.ooknet.hardware) monitors;
in {
  wayland.windowManager.hyprland.settings.monitor =
    map (
      m:
        {output = m.name;}
        // (
          if m.enabled
          then {
            mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
            scale = 1;
          }
          else {disabled = true;}
        )
        // optionalAttrs (m.transform != 0) {inherit (m) transform;}
    )
    monitors;
}
