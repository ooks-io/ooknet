{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.nvim.dag) entryBefore;
  inherit (lib.nvim.lua) toLuaObject;

  cfg = config.vim.theme.custom;

  themePlugin = pkgs.vimUtils.buildVimPlugin {
    inherit (cfg) name;
    src = pkgs.writeTextDir "colors/${cfg.name}.lua" ''
      local M = {}
      M.highlights = ${toLuaObject cfg.highlights}

      local function set_groups()
        for group, settings in pairs(M.highlights) do
          vim.api.nvim_set_hl(0, group, settings)
        end
      end

      function M.colorscheme()
        vim.api.nvim_command("hi clear")
        if vim.fn.exists("syntax_on") then
          vim.api.nvim_command("syntax reset")
        end

        vim.o.termguicolors = true
        vim.g.colors_name = "${cfg.name}"

        set_groups()
      end

      return M.colorscheme()
    '';
  };
in {
  config = mkIf cfg.enable {
    vim = {
      startPlugins = [themePlugin];
      luaConfigRC.customTheme = ''
        vim.cmd.colorscheme("${cfg.name}")
      '';
    };
  };
}
