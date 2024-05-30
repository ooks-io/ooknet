{ lib, config, ... }:

let
  cfg = config.ooknet.desktop.wayland.windowManager.hyprland;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = lib.concatMap (m: let
        resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
        basicConfig = "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}";
      in
        [ basicConfig ] ++ (if m.transform != 0 then ["${m.name},transform,${toString m.transform}"] else [])
      ) (config.monitors);
    };
  };
}

