{
  osConfig,
  pkgs,
  ...
}: let
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

      # Dark system theme
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

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
