{ config, lib, ... }:
let
  inherit (config.colorscheme) palette variant;
  fonts = config.ooknet.theme.fonts;
  cfg = config.ooknet.desktop.wayland.notification.mako;
in {
  config = lib.mkIf cfg.enable {
    services.mako  = {
      enable = true;
      iconPath =
        if variant == "dark" then
          "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark"
        else
          "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";
      font = "${fonts.regular.family} 12";
      padding = "10,10";
      anchor = "top-right";
      width = 300;
      height = 100;
      borderSize = 2;
      defaultTimeout = 3000;
      backgroundColor = "#${palette.base00}dd";
      borderColor = "#${palette.base05}dd";
      textColor = "#${palette.base05}dd";
      extraConfig = ''
        [app-name="system-notify"]
        padding=3,3
        width=100
        height=100
        [urgency=critical]
        padding=3,3
        width=100
        height=100
        anchor=top-center
        border-color=#${palette.base08}dd
      '';
    };
  };
}

