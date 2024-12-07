{pkgs, ...}: {
  vim = {
    package = pkgs.neovim-unwrapped;
    searchCase = "smart";
    enableLuaLoader = true;
    enableEditorconfig = true;
    useSystemClipboard = true;
    autopairs.nvim-autopairs.enable = true;
    hideSearchHighlight = true;
    theme = {
      enable = false;
    };
  };
}
