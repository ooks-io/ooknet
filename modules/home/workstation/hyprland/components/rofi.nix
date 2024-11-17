{
  lib,
  config,
  osConfig,
  hozen,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (osConfig.ooknet.workstation) environment;
  inherit (hozen) color;
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  config = mkIf (environment == "hyprland") {
    programs.rofi = {
      enable = true;
      font = "${fonts.monospace.family}";
      package = pkgs.rofi-wayland;
      terminal = "${config.home.sessionVariables.TERMINAL}";
      theme = {
        "*" = {
          background = mkLiteral "#${color.layout.menu}";
          foreground = mkLiteral "#${color.typography.text}";
          selected = mkLiteral "#${color.primary.base}";
          message = mkLiteral "#${color.blue.base}";

          background-color = mkLiteral "@background";
          border-color = mkLiteral "@foreground";
          text-color = mkLiteral "@foreground";
          font = mkLiteral "'${fonts.monospace.family} 14'";
        };

        "window" = {
          width = mkLiteral "15%";
          border = mkLiteral "2";
          padding = mkLiteral "10";
          children = mkLiteral "[message,listview,inputbar]";
        };

        "message" = {
          children = mkLiteral "[textbox]";
        };

        "textbox" = {
          text-color = mkLiteral "@message";
          horizontal-align = mkLiteral "0.50";
        };

        "inputbar" = {
          cursor = mkLiteral "pointer";
          border = mkLiteral "2";
          children = mkLiteral "[textbox-prompt-colon,entry]";
        };

        "entry" = {
          cursor = mkLiteral "false";
        };

        "textbox-prompt-colon" = {
          text-color = mkLiteral "@selected";
          expand = mkLiteral "false";
          margin = mkLiteral "0 0.3em 0em 0em";
          str = mkLiteral "'  '";
        };

        "listview" = {
          scrollbar = mkLiteral "true";
          fixed-height = mkLiteral "false";
          dynamic = mkLiteral "true";
        };

        "element-text" = {
          horizontal-align = mkLiteral "0.50";
        };

        "element-text selected" = {
          text-color = mkLiteral "@selected";
        };
      };
    };
  };
}
