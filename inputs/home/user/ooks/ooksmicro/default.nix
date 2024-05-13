{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland"];

  home.sessionVariables.HN = "ooksmicro";

  monitors = [{
    name = "DSI-1";
    width = 720;
    height = 1280;
    workspace = "1";
    primary = true;
    transform = 3;
  }];

  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-soft;
}

