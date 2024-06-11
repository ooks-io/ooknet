{ lib, config, pkgs, inputs, ... }:

let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (lib) mkIf;
  theme = config.ooknet.theme;
in

{
  config = mkIf (theme == "phone") {

    colorscheme = colorSchemes.gruvbox-material-dark-soft;
    home.file.".colorscheme".text = config.colorscheme.slug;
    home.sessionVariables.COLOR_SCHEME = "${config.colorscheme.slug}";

    ooknet.theme = {
      fonts.enable = true;
      fonts.regular = {
        family = "Fira Sans";
        package = pkgs.fira;
      };
      fonts.monospace = {
        family = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
    };
  };
}
