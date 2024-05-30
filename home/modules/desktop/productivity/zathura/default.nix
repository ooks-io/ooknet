{ lib, config, ... }:

let
  cfg = config.ooknet.desktop.productivity.zathura;
  inherit (config.colorscheme) palette;
  fonts = config.ooknet.theme.fonts;
in

{
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        font = "${fonts.regular.family} 14";
        recolor = true;
        selection-clipboard = "clipboard";
        default-bg = "#${palette.base00}";
        default-fg = "#${palette.base01}";
        statusbar-bg = "#${palette.base02}";
        statusbar-fg = "#${palette.base04}";
        inputbar-bg = "#${palette.base00}";
        inputbar-fg = "#${palette.base07}";
        notification-bg = "#${palette.base00}";
        notification-fg = "#${palette.base07}";
        notification-error-bg = "#${palette.base00}";
        notification-error-fg = "#${palette.base08}";
        notification-warning-bg = "#${palette.base00}";
        notification-warning-fg = "#${palette.base08}";
        highlight-color = "#${palette.base0A}";
        highlight-active-color = "#${palette.base0D}";
        completion-bg = "#${palette.base01}";
        completion-fg = "#${palette.base05}";
        completions-highlight-bg = "#${palette.base0D}";
        completions-highlight-fg = "#${palette.base07}";
        recolor-lightcolor = "#${palette.base00}";
        recolor-darkcolor = "#${palette.base06}";
      };
    };
  };
}
