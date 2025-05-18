{
  osConfig,
  hozen,
  lib,
  ...
}: let
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (hozen) color;
  inherit (lib) mkIf;
in {
  config = mkIf (environment == "hyprland") {
    services.mako = {
      enable = true;
      settings = {
        layer = "overlay";
        font = "${fonts.regular.family} 12";
        anchor = "top-right";
        width = 300;
        height = 100;
        borderSize = 2;
        defaultTimeout = 3000;
        backgroundColor = "#${color.layout.menu}";
        borderColor = "#${color.border.active}";
        textColor = "#${color.typography.text}";
        "appname='system-notify'" = {
          text-alignment = "center";
          anchor = "top-center";
          width = 100;
          height = 100;
        };
        "app-name='spotify_player'" = {
          border-color = "#${color.green.base}";
        };
        "urgency=critical" = {
          padding = "3,3";
          width = 300;
          height = 100;
          anchor = "top-center";
          border-color = "#${color.red.base}dd";
        };
      };
      # extraConfig = ''
      #   [app-name="system-notify"]
      #   text-alignment=center
      #   font=${fonts.regular.family} 16
      #   anchor=top-center
      #   width=100
      #   height=100
      #   [app-name="spotify_player"]
      #   border-color=#${color.green.base}
      #   [urgency=critical]
      #   padding=3,3
      #   width=300
      #   height=100
      #   anchor=top-center
      #   border-color=#${color.red.base}dd
      # '';
    };
  };
}
