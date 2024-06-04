{ config, pkgs, inputs, lib, ... }:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  inherit (lib) mkIf;
  cfg = config.ooknet.gtk;
in
{
  config = mkIf cfg.enable (rec {
    gtk = {
      enable = true;
      font = {
        name = config.ooknet.fonts.regular.family;
        size = 12;
      };
      theme = {
        name = config.colorscheme.slug;
        package = gtkThemeFromScheme { scheme = config.colorscheme; };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    services.xsettingsd = {
      enable = true;
      settings = {
        "Net/ThemeName" = gtk.theme.name;
        "Net/IconThemeName" = gtk.iconTheme.name;
      };
    };
  });
}

