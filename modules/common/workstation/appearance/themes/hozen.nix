{
  config,
  lib,
  pkgs,
  ook,
  ...
}: let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (config.ooknet.workstation) theme;
  generatedWallpaper = import ./generated-wallpaper.nix {inherit ook config pkgs;} {};
in {
  config = mkIf (theme == "hozen") {
    ooknet.appearance = {
      fonts = {
        monospace = {
          bitmap = true;
          package = pkgs.monocraft;
          size = 18;
          family = "Monocraft";
          variants = {
            regular = "Monocraft:style=Medium";
            bold = "Monocraft:style=Medium";
            italic = "Monocraft:style=Medium";
            boldItalic = "Monocraft:style=Medium";
          };
          fallback = {
            family = "JetBrainsMono NFM";
            variants = {
              regular = "JetBrainsMono NFM:style=Regular";
              bold = "JetBrainsMono NFM:style=Bold";
              italic = "JetBrainsMono NFM:style=Italic";
              boldItalic = "JetBrainsMono NFM:style=Bold Italic";
            };
            package = pkgs.nerd-fonts.jetbrains-mono;
            size = 18;
          };
        };
        regular = {
          family = "Fira Sans";
          variants = {
            regular = "Fira Sans:style=Regular";
            bold = "Fira Sans:style=Bold";
            italic = "Fira Sans:style=Italic";
            boldItalic = "Fira Sans:style=Bold Italic";
          };
          package = pkgs.fira;
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
