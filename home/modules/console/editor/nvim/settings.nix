{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.nixvim = {
      opts = {

        # line numbers
        relativenumber = true;
        number = true;

        # command line height
        cmdheight = 2;

        # popup menu height (0 == use all available space)
        pumheight = 0;
        
        hidden = true;

        # mouse mode
        mouse = "a";
        mousemodel = "extend";

        # undo history
        undofile = true;
        swapfile = false;
        backup = false;

        # tab size
        tabstop = 2;
        expandtab = true;
        showtabline = 2;
        softtabstop = 2;

        # auto indenting
        smartindent = true;
        shiftwidth = 2;
        
        # text wrapping
        wrap = true;

        # fold settings
        foldcolumn = "0";
        foldlevel = 99;
        foldlevelstart = 99;
        foldenable = true;
        
        # which-key timeout
        timeoutlen = 10;

        # faster updatetime
        updatetime = 50;

        # cursor position unless at start/end
        scrolloff = 8;

        # 24 bit colors
        termguicolors = true;

        # highlight cursor line
        cursorline = true;

        # encoding
        encoding = "utf-8";
        fileencoding = "utf-8";

        # chars list
        # list = true;
        # listchars = "eol:↲,tab:|->,lead:·,space: ,trail:•,extends:→,precedes:←,nbsp:␣";
        
        # splitting
        splitbelow = true;
        splitright = true;
            
        # better searching
        ignorecase = true;
        grepprg = "rg --vimgrep";
        grepformat = "%f:%l:%c:%m";
        smartcase = true;
        
        # prevent screen jumping
        signcolumn = "yes";

        incsearch = true;
        autoindent = true;
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };
    };
  };
}
