{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland" "productivity" "gaming"];

  theme.minimal.enable = true;

  home.sessionVariables.HN = "ooksdesk";
}

