{
  vim.autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    sourcePlugins = {
      emoji.enable = false;
      spell.enable = false;
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
        ];
      };
      snippets.preset = "luasnip";
    };
  };
}
