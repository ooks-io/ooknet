{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.wayland;
in
{
  imports = [
    ./bar
    ./lockscreen
    ./notification
    ./utility
    ./windowManager
    ./launcher
  ];

  options.homeModules.desktop.wayland = {
    enable = lib.mkEnableOption "Enable wayland specific confurations";
    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nvidia wayland configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
    } // lib.mkIf cfg.nvidia {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
