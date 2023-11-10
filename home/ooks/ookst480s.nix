{ inputs, outputs, ... }:

{
  imports = [
    ./opt/desktop/hyprland
    ./features/essentials
    ./base  
  ];

  monitor = [{
    name = "eDP-1";
    width = "1920";
    height = "1080";
    workspace = "1";
    primary = true;
    transform = "0";
  }];
  
  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;

}