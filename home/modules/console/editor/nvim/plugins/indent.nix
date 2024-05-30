{ config, lib, ... }:

let
  cfg = config.ooknet.console.editor.nvim.plugins;
in

{
  config = lib.mkIf cfg.indentBlankline {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
    };
  };
}
