{pkgs, ...}: {
  vim.treesitter = {
    enable = true;
    fold = true;
    addDefaultGrammars = true;
    autotagHtml = true;
    grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      kdl
      regex
      fish
      yaml
      typescript
      qmljs
    ];
    highlight.enable = true;
    indent.enable = true;
    context.enable = false;
  };
}
