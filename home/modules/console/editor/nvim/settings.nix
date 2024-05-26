{ config, lib, ... }:

let
  inherit (config.colorscheme) palette;
  cfg = config.homeModules.console.editor.nvim;
in

{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      options = {
        relativenumber = true;
        number = true;
        hidden = true;
        mouse = "a";
        mousemodel = "extend";
        undofile = true;
        swapfile = false;
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        fileencoding = "utf-8";
        termguicolors = true;
        autoindent = true;
        shiftwidth = 2;
        smartindent = true;
        expandtab = true;
        updatetime = 100;
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      colorschemes.base16 = {
        enable = true;
        colorscheme = config.colorscheme.slug;
        customColorScheme = {
          base00 = "#${palette.base00}";
          base01 = "#${palette.base01}";
          base02 = "#${palette.base02}";
          base03 = "#${palette.base03}";
          base04 = "#${palette.base04}";
          base05 = "#${palette.base05}";
          base06 = "#${palette.base06}";
          base07 = "#${palette.base07}";
          base08 = "#${palette.base08}";
          base09 = "#${palette.base09}";
          base0A = "#${palette.base0A}";
          base0B = "#${palette.base0B}";
          base0C = "#${palette.base0C}";
          base0D = "#${palette.base0D}";
          base0E = "#${palette.base0E}";
          base0F = "#${palette.base0F}";
        };
      };
    };
  };
}