{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.appearance) fonts;

  gtkCss = import ./gtkCss.nix {inherit osConfig;};
in {
  config = rec {
    gtk = {
      enable = true;
      font = {
        name = fonts.regular.family;
        size = 12;
      };
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
      gtk3.extraCss = gtkCss;
      gtk4.extraCss = gtkCss;
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
