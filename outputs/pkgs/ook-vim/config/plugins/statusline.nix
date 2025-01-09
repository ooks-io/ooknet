{
  vim.statusline.lualine = {
    enable = true;
    activeSection = {
      # most of this are the default values provided by nvf
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
      c = [
        #lua
        ''
          "%=",
            {
              "filename",
              symbols = {modified = ' ', readonly = ' '},
              separator = {right = ' '},
              path = 1,
            }
        ''
      ];
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
      y = [
        #lua
        ''
          {
            "",
            draw_empty = true,
            separator = { left = ' ', right = ' ' }
          }
        ''
        ''
          {
            'searchcount',
            maxcount = 999,
            timeout = 120,
            separator = {left = ' '}
          }
        ''
        ''
          {
            "branch",
            icon = ' •',
            separator = {left = ' '}
          }
        ''
      ];
      z = [
        #lua
        ''
          {
            "",
            draw_empty = true,
            separator = { left = ' ', right = ' ' }
          }
        ''
        ''
          {
            "progress",
            separator = {left = ' '}
          }
        ''
        ''
          {"location"}
        ''
        ''
          {
            "fileformat",
            color = {fg='black'},
            symbols = {
              unix = '', -- e712
              dos = '',  -- e70f
              mac = '',  -- e711
            }
          }
        ''
      ];
    };
  };
}
