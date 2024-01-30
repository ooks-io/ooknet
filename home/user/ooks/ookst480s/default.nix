{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland"];

  homeModules.console.editor.nvim.enable = true;
  
  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
    workspace = "1";
    primary = true;
    transform = 0;
  }];

  colorscheme = inputs.nix-colors.colorSchemes.everforest;
}

