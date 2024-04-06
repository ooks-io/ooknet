{ lib, config, pkgs, ... }:

let
  fonts = config.homeModules.theme.fonts;
  cfg = config.homeModules.desktop.wayland.launcher.rofi;
in

{
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      font = "${fonts.monospace.family}";
      package = pkgs.rofi-wayland;
      terminal = "${config.home.sessionVariables.TERMINAL}";
      theme = let
        inherit (config.colorscheme ) colors;
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          background = mkLiteral "#${colors.base00}";
          foreground = mkLiteral "#${colors.base05}";
          selected = mkLiteral "#${colors.base0B}";
          message = mkLiteral "#${colors.base0D}";

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
