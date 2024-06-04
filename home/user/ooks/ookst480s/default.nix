{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland" "productivity"];

  ooknet = {
    theme = "minimal";
    desktop = {
      environment = "hyprland";
      browser = "firefox";
      terminal = "foot";
      notes = "obsidian";
      discord = "vesktop";
    };
  };
  home.sessionVariables.HN = "ookst480s";
}

