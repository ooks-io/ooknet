{lib, ...}: let
  inherit (lib.nvim.binds) mkMappingOption;
in {
  options.vim.notes.obsidian = {
    mappings = {
      openNote = mkMappingOption "Open obsidian note" "<leader>oo";
    };
  };
}
