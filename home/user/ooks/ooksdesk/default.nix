{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland"];

  homeModules.console.editor.nvim = {
    enable = true;
    plugins = {
      lualine = true;
      telescope = true;
      indentBlankline = true;
    };
  };
  homeModules.desktop.wayland.windowManager.hyprland.nvidia = true;
  
  monitors = [{
    name = "DP-1";
    width = 2560;
    height = 1440;
    refreshRate = 155;
    workspace = "1";
    primary = true;
  }];

  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-soft;
}

