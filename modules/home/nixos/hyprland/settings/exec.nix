{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings.on = [
    {
      _args = [
        "hyprland.start"
        (lib.generators.mkLuaInline ''
          function()
            hl.exec_cmd("${pkgs._1password-gui}/bin/1password --silent")
          end'')
      ];
    }
  ];
}
