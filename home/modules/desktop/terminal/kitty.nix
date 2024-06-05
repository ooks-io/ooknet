{ config, lib, osConfig, ... }:

let
  inherit (lib) mkIf;
  inherit (config.colorscheme) palette;
  fonts = config.ooknet.fonts;
  cfg = config.ooknet.terminal.kitty;
  terminal = config.ooknet.desktop.terminal;
  shell = osConfig.ooknet.host.admin.shell;
in

{
  config = mkIf (cfg.enable || terminal == "kitty") {

    home.sessionVariables = mkIf (terminal == "kitty") {
      TERMINAL = "kitty -1";
      TERM = "kitty -1";
    };

    ooknet.binds.terminal = mkIf (terminal == "kitty") "kitty -1";
    ooknet.binds.terminalLaunch = mkIf (terminal == "kitty") "kitty -e";

    programs.kitty = {
      enable = true;
      font = {
        name = fonts.monospace.family;
        size = 12;
      };
      shellIntegration.enableFishIntegration = mkIf (shell == "fish") true;
      settings = {
        scrollback_lines = 4000;
        scrollback_pager_history_size = 2048;
        window_padding_width = 1;
        foreground = "#${palette.base05}";
        background = "#${palette.base00}";
        background_opacity = "1.0";
        selection_background = "#${palette.base05}";
        selection_foreground = "#${palette.base00}";
        url_color = "#${palette.base04}";
        cursor = "#${palette.base05}";
        active_border_color = "#${palette.base03}";
        inactive_border_color = "#${palette.base01}";
        active_tab_background = "#${palette.base00}";
        active_tab_foreground = "#${palette.base05}";
        inactive_tab_background = "#${palette.base01}";
        inactive_tab_foreground = "#${palette.base04}";
        tab_bar_background = "#${palette.base01}";
        color0 = "#${palette.base00}";
        color1 = "#${palette.base08}";
        color2 = "#${palette.base0B}";
        color3 = "#${palette.base0A}";
        color4 = "#${palette.base0D}";
        color5 = "#${palette.base0E}";
        color6 = "#${palette.base0C}";
        color7 = "#${palette.base05}";
        color8 = "#${palette.base03}";
        color9 = "#${palette.base08}";
        color10 = "#${palette.base0B}";
        color11 = "#${palette.base0A}";
        color12 = "#${palette.base0D}";
        color13 = "#${palette.base0E}";
        color14 = "#${palette.base0C}";
        color15 = "#${palette.base07}";
        color16 = "#${palette.base09}";
        color17 = "#${palette.base0F}";
        color18 = "#${palette.base01}";
        color19 = "#${palette.base02}";
        color20 = "#${palette.base04}";
        color21 = "#${palette.base06}";
      };
    };
  };
}
