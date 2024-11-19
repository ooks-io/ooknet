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
          family = "JetBrainsMono Nerd Font";
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        };
        regular = {
          family = "Fira Sans";
          package = pkgs.fira;
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
