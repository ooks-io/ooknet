{ config, lib, ... }:

let
  cfg = config.homeModules.console.editor.nvim.plugins;
in

{
  config = lib.mkIf cfg.indentBlankline {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
    };
  };
}
