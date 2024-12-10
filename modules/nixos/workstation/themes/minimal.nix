{
  config,
  lib,
  pkgs,
  hozen,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.workstation) theme;
  generatedWallpaper = import ./generated-wallpaper.nix {inherit hozen config pkgs;} {};
in {
  config = mkIf (theme == "minimal") {
    ooknet.appearance = {
      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
          size = 18;
          family = "JetBrainsMono NF";
          variants = {
            regular = "JetBrainsMono NF:style=Regular";
            bold = "JetBrainsMono NF:style=Bold";
            italic = "JetBrainsMono NF:style=Italic";
            boldItalic = "JetBrainsMono NF:style=Bold Italic";
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
        path = "${generatedWallpaper}";
      };
    };
  };
}
