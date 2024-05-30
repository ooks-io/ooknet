{ config, pkgs, inputs, lib, ... }:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  cfg = config.ooknet.theme.gtk;
in
{
  options.ooknet.theme.gtk = {
    enable = lib.mkEnableOption "Enable gtk theme module";
    # TODO: add theme option
  };

  config = lib.mkIf cfg.enable (rec {
    gtk = {
      enable = true;
      font = {
        name = config.ooknet.theme.fonts.regular.family;
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

