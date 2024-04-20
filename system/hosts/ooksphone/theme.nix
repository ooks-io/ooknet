{ pkgs, ... }:

let
  fontPackage = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
  fontPath = "/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontMono-Regular.ttf";
in

{
  terminal = {
    font = fontPackage + fontPath;

    # Gruvbox Material Dark Soft
    colors = {
      background = "#32302F";
      foreground = "#DDC7A1";
      cursor = "#DDC7A1";

      color0 = "#32302F"; # Black
      color8 = "#7C6F64"; # Bright Black

      color1 = "#EA6962"; # Red
      color9 = "#EA6962"; # Bright Red

      color2 = "#A9B665"; # Green
      color10 = "#A9B665"; # Bright Green

      color3 = "#D8A657"; # Yellow
      color11 = "#D8A657"; # Bright Yellow

      color4 = "#7DAEA3"; # Blue
      color12 = "#7DAEA3"; # Bright Blue

      color5 = "#D3869B"; # Magenta
      color13 = "#D3869B"; # Bright Magenta

      color6 = "#89B482"; # Cyan
      color14 = "#89B482"; # Bright Cyan

      color7 = "#DDC7A1"; # White
      color15 = "#FBF1C7"; # Bright White
    };
  };
}
