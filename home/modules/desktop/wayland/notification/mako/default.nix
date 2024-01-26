{ config, lib, ... }:
let
  inherit (config.colorscheme) colors kind;
  cfg = config.homeModules.desktop.wayland.notification.mako;
in {
  config = lib.mkIf cfg.enable {
    services.mako  = {
      enable = true;
      iconPath =
        if kind == "dark" then
          "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark"
        else
          "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";
      font = "${config.fontProfiles.regular.family} 12";
      padding = "10,10";
      anchor = "top-right";
      width = 300;
      height = 100;
      borderSize = 2;
      defaultTimeout = 3000;
      backgroundColor = "#${colors.base00}dd";
      borderColor = "#${colors.base05}dd";
      textColor = "#${colors.base05}dd";
      extraConfig = ''
        [app-name="system-notify"]
        padding=3,3
        width=100
        height=100
        [app-name="bat-notify"]
        padding=3,3
        width=100
        height=100
        anchor=top-center
      '';
    };
  };
}

