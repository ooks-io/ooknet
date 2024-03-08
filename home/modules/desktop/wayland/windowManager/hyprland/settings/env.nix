{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in

{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.env = [
      "CLUTTER_BACKEND,wayland"
      "NIXOS_OZONE_WL,1"
      "GDK_BACKEND,wayland"
      "QT_QPA_PLATFORM,wayland"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "MOZ_ENABLE_WAYLAND,1"
      "MOZ_DBUS_REMOTE,1"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSIONDESKTOP,hyprland"
      "XDG_CURRENT_DESKTOP,hyprland"
    ] ++ lib.optionals cfg.nvidia [
      "LIBVA_DRIVER_NAME,nvidia"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDEOR_LIBRARY_NAME,nvidia"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];
  };

  
}
