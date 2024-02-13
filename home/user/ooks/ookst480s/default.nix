{ inputs, outputs, config, ... }:

{
  imports = [
    ../../../profile
  ];

  activeProfiles = ["base" "hyprland"];

  home.sessionVariables.HN = "ookst480s";

  homeModules.console.editor.nvim = {
    enable = true;
    plugins = {
      lualine = true;
      telescope = true;
      indentBlankline = true;
    };
  };
  
  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
    workspace = "1";
    primary = true;
    transform = 0;
  }];

  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-soft;
}

