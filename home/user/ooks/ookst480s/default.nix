{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland" "productivity"];

  theme.minimal.enable = true;

  home.sessionVariables.HN = "ookst480s";
  
  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
    workspace = "1";
    primary = true;
    transform = 0;
  }];
}

