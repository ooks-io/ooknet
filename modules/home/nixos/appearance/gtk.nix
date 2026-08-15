{
  osConfig,
  ook,
  pkgs,
  ...
}: let
  inherit (osConfig.ooknet.appearance) fonts;

  gtkCss = import ./gtkCss.nix {inherit ook;};
  theme = {
    name = "adw-gtk3";
    package = pkgs.adw-gtk3;
  };
in {
  config = rec {
    gtk = {
      enable = true;
      font = {
        name = fonts.regular.family;
        size = 12;
      };
      inherit theme;
      # hm 26.05 drops gtk4 theme inheritance, keep it explicit
      gtk4.theme = theme;
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-dark-icons-gtk;
      };
      gtk3.extraCss = gtkCss;
      gtk4.extraCss = gtkCss;

      # Dark system theme
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gtk/Settings/Debug".enable-inspector-keybinding = true;
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
