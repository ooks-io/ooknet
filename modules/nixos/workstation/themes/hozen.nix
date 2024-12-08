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
  config = mkIf (theme == "hozen") {
    ooknet.appearance = {
      fonts = {
        monospace = {
          family = "CozetteHiDpi";
          package = pkgs.cozette;
          size = 22;
          fallback = {
            family = "JetBrainsMono Nerd Font";
            package = pkgs.nerfonts.override {fonts = ["JetBrainsMono"];};
            size = 18;
          };
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
