{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf concatMap;
  wayland = config.ooknet.wayland;
  monitors = osConfig.ooknet.host.hardware.monitors;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      monitor = concatMap (m: let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
        basicConfig = "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}";
      in
        [ basicConfig ] ++ (if m.transform != 0 then ["${m.name},transform,${toString m.transform}"] else [])
      ) (monitors);
    };
  };
}

