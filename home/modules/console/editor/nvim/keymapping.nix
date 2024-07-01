{ config, lib, ... }:

let
  inherit (lib) mkIf mapAttrsToList;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.nixvim = {
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>f";
          action = "+find/file";
        }
      ]; 
    };
  };
}
