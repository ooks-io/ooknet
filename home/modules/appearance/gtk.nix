{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.appearance.colorscheme) palette;
  cfg = config.ooknet.gtk;
in {
  config = mkIf cfg.enable rec {
    gtk = {
      enable = true;
      font = {
        name = config.ooknet.fonts.regular.family;
        size = 12;
      };
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    #TODO: add gtk css configuration

    services.xsettingsd = {
      enable = true;
      settings = {
        "Net/ThemeName" = gtk.theme.name;
        "Net/IconThemeName" = gtk.iconTheme.name;
      };
    };
  };
}
