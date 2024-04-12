{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland" "productivity" "gaming"];

  theme.minimal.enable = true;

  home.sessionVariables.HN = "ooksmedia";

  homeModules.desktop.wayland.nvidia = true;
  
  monitors = [{
    name = "HDMI-A-1";
    width = 1920;
    height = 1080;
    refreshRate = 60;
    workspace = "1";
    primary = true;
  }];
}

