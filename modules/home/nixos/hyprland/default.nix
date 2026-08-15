{
  lib,
  osConfig,
  ...
}: let
  inherit (osConfig.ooknet.workstation) environment;
  inherit (osConfig.ooknet.hardware) gpu;
  inherit (lib) optionalAttrs mkIf;
in {
  imports = [
    ./settings
    ./components
  ];

  config = mkIf (environment == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      # HM flipped the default to "lua"; keep hyprlang for our structured settings
      configType = "hyprlang";
      package = null;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
    # hm hyprland module force-enables xdg.portal, mirror the system portal config
    # so the user-level portals.conf matches instead of warning
    xdg.portal.config = {
      hyprland.default = ["gtk" "hyprland"];
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Screencast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
      };
    };
    home.sessionVariables =
      {
        NIXOS_OZONE_WL = "1";
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        DISABLE_QT5_COMPAT = "0";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_DBUS_REMOTE = "1";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_CURRENT_DESKTOP = "Hyprland";
      }
      // optionalAttrs (gpu.type == "nvidia") {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
  };
}
