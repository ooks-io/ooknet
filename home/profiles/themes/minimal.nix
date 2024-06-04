{ lib, config, pkgs, inputs, ... }:

let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (lib) mkIf;
  theme = config.ooknet.theme;
in

{
  imports = [ inputs.nix-colors.homeManagerModule ];
  config = mkIf (theme == "minimal") {

    colorscheme = colorSchemes.gruvbox-material-dark-soft;
    home.file.".colorscheme".text = config.colorscheme.slug;
    home.sessionVariables.COLOR_SCHEME = "${config.colorscheme.slug}";

    ooknet = {
      fonts.enable = true;
      fonts.regular = {
        family = "Fira Sans";
        package = pkgs.fira;
      };
      fonts.monospace = {
        family = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };

      cursor.enable = true;
      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 22;
      };

      wallpaper = {
        enable = true;
      };
    
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
