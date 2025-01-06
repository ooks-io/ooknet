{
  vim.statusline.lualine = {
    enable = true;
    activeSection = {
      a = [
        #lua
        ''
          {
            "mode",
            icons_enabled = true,
            seperator = {left = "", right = " ", }
          }
        ''
        #lua
        ''
          {
            draw_empty = true,
            seperator = { left = " ", right = " " }
          }
        ''
      ];
      b = [
        #lua
        ''
          {
            "",
            draw_empty = true,
          }
        ''
      ];
      c = ["filename"];
      x = [
        # lua
        ''
          {
            "diagnostics",
              sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp'},
              symbols = {error = '󰅙 ', warn = ' ', info = ' ', hint = '󰌵 '},
              colored = true,
              update_in_insert = false,
              always_visible = false,
              diagnostics_color = {
                color_error = { fg = 'red' },
                color_warn = { fg = 'yellow' },
                color_info = { fg = 'cyan' },
              }
          }
        ''
      ];
    };
  };
}
