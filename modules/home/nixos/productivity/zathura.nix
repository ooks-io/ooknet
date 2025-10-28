{
  lib,
  osConfig,
  ook,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (osConfig.ooknet.workstation) profiles;
  inherit (ook) color;

  zathuraMime = {"application/pdf" = ["org.pwmt.zathura.desktop"];};
in {
  config = mkIf (elem "productivity" profiles) {
    programs.zathura = {
      enable = true;
      options = {
        font = "${fonts.regular.family} 14";
        recolor = true;
        selection-clipboard = "clipboard";
        default-bg = "#${color.layout.body}";
        default-fg = "#${color.typography.text}";
        statusbar-bg = "#${color.layout.header}";
        statusbar-fg = "#${color.typography.text}";
        inputbar-bg = "#${color.layout.menu}";
        inputbar-fg = "#${color.typography.text-bright}";
        notification-bg = "#${color.layout.menu}";
        notification-fg = "#${color.typography.text}";
        notification-error-bg = "#${color.layout.menu}";
        notification-error-fg = "#${color.error.base}";
        notification-warning-bg = "#${color.layout.menu}";
        notification-warning-fg = "#${color.warning.base}";
        highlight-color = "#${color.primary.base}";
        highlight-active-color = "#${color.primary.hard1}";
        completion-bg = "#${color.layout.menu}";
        completion-fg = "#${color.typography.text}";
        completion-highlight-bg = "#${color.primary.base}";
        completion-highlight-fg = "#${color.typography.contrast-text}";
        recolor-lightcolor = "#${color.typography.text}";
        recolor-darkcolor = "#${color.layout.body}";
      };
    };
    xdg.mimeApps = {
      associations.added = zathuraMime;
      defaultApplications = zathuraMime;
    };
  };
}
