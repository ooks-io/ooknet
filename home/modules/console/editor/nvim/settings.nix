{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
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

      colorscheme = "${config.colorscheme.slug}";
    };
  };
}
