{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) desktop;
in {
  config = mkIf (desktop.environment == "hyprland") {
    ooknet.wayland = {
      enable = true;
      compositor = "hyprland";
      launcher = "rofi";
      locker = "hyprlock";
      notification = "mako";
      bar = "waybar";
    };
    ooknet.security.polkit = "pantheon";
  };
}
