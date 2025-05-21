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
        border-size = 2;
        default-timeout = 3000;
        background-color = "#${color.layout.menu}";
        border-color = "#${color.border.active}";
        text-color = "#${color.typography.text}";
        "app-name=system-notify" = {
          text-alignment = "center";
          anchor = "top-center";
          width = 100;
          height = 100;
        };
        "app-name=spotify_player" = {
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
    };
  };
}
