{
  config,
  lib,
  pkgs,
  ook,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
  inherit (config.ooknet.workstation) theme;
  generatedWallpaper = import ./generated-wallpaper.nix {inherit ook config pkgs;} {};
in {
  config = mkIf (theme == "minimal") {
    ooknet.appearance = {
      fonts = {
        monospace = {
          package = inputs'.secrets.packages.berkeley-nerd-mono;
          size = 16;
          family = "BerkeleyMono Nerd Font";
          variants = {
            regular = "BerkeleyMono Nerd Font:style=Regular";
            bold = "BerkeleyMono Nerd Font:style=Bold";
            italic = "BerkeleyMono Nerd Font:style=Italic";
            boldItalic = "BerkeleyMono Nerd Font:style=Bold Italic";
          };
        };
        regular = {
          package = pkgs.fira;
          family = "Fira Sans";
          variants = {
            regular = "Fira Sans:style=Regular";
            bold = "Fira Sans:style=Bold";
            italic = "Fira Sans:style=Italic";
            boldItalic = "Fira Sans:style=Bold Italic";
          };
        };
      };

      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 22;
      };

      wallpaper = {
        path = mkIf isLinux "${generatedWallpaper}";
      };
    };
  };
}
