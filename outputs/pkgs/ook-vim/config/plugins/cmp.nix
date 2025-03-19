{
  vim.autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    sourcePlugins = {
      emoji.enable = true;
      spell.enable = true;
      ripgrep.enable = true;
    };
    setupOpts = {
      signature.enabled = true;
      sources = {
        default = [
          "lsp"
          "path"
          "buffer"
          "snippets"
          "emoji"
        ];
      };
      snippets.preset = "luasnip";
      cmdline.sources = [];
    };
  };
}
