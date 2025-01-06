{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.nvim.binds) mkKeymap;
  inherit (options.vim.notes.obsidian) mappings;

  cfg = config.vim.notes.obsidian;
  keys = cfg.mappings;
in {
  config = mkIf cfg.enable {
    vim = {
      keymaps = [
        (mkKeymap "n" keys.openNote "<cmd>ObsidianOpen<CR>" {desc = mappings.openNote.description;})
      ];
    };
  };
}
