{
  vim.gruvbox-material = {
    enable = true;
    contrast = "medium";
    italics = false;
    transparent = false;
    extraConfig =
      # lua
      ''
        local g_colors = require("gruvbox-material.colors")
        local colors = g_colors.get(vim.o.background, "soft")

        -- Noice
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderHelp", { fg = colors.yellow  })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = colors.grey1  })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = colors.green  })
        vim.api.nvim_set_hl(0, "NoiceCmdLinePopupTitle", { fg = colors.grey1  })
      '';
  };
}
