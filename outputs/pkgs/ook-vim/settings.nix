{pkgs, ...}: {
  vim = {
    package = pkgs.neovim-unwrapped;
    leaderKey = " ";
    tabWidth = 2;
    autoIndent = true;
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
  # Additional sets can be added here
  # vim.luaConfigRC.basic =
  #   entryAfter ["entryAfter"] #lua
  #     ''
  #
  #     '';
}
