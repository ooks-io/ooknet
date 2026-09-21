{
  config,
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig.ooknet.appearance) fonts;

  inherit (config.ooknet.appearance) scheme;
  gtkCss = import ./gtkCss.nix {color = config.ooknet.appearance.colors;};
  theme = {
    # gtk3 apps pick the variant up live from gsettings, prefer-dark does not
    name =
      if scheme == "dark"
      then "adw-gtk3-dark"
      else "adw-gtk3";
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

      gtk3.extraConfig.gtk-application-prefer-dark-theme = scheme == "dark";
      gtk4.extraConfig.gtk-application-prefer-dark-theme = scheme == "dark";
    };

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-${scheme}";
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
