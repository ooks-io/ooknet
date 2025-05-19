{pkgs, ...}: {
  vim = {
    package = pkgs.neovim-unwrapped;
    searchCase = "smart";
    enableLuaLoader = true;
    autopairs.nvim-autopairs.enable = true;
    hideSearchHighlight = true;
    theme = {
      enable = false;
    };
    spellcheck = {
      enable = true;
    };
    clipboard = {
      enable = true;
      registers = "unnamedplus";
    };
  };
}
