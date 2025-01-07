{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (lib.nvim.binds) mkKeymap pushDownDefault;
  inherit (options.vim.notes.obsidianExtended) mappings;

  cfg = config.vim.notes.obsidianExtended;
  keys = cfg.mappings;
in {
  config = mkIf cfg.enable {
    vim = {
      startPlugins = [
        "obsidian-nvim"
        "vim-markdown"
        "tabular"
      ];

      binds.whichKey.register = pushDownDefault {
        "<leader>o" = "+Notes";
      };

      pluginRC.obsidian = entryAnywhere ''
        require("obsidian").setup(${toLuaObject cfg.setupOpts})
      '';
      keymaps = [
        (mkKeymap "n" keys.openNote "<cmd>ObsidianOpen<CR>" {desc = mappings.openNote.description;})
        (mkKeymap "n" keys.findNote "<cmd>ObsidianQuickSwitch<CR>" {desc = mappings.findNote.description;})
      ];
    };
  };
}
