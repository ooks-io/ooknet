{pkgs, ...}: {
  vim.treesitter = {
    enable = true;
    fold = true;
    grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      kdl
      regex
      fish
      yaml
    ];
  };
}
