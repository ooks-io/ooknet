{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.nixvim.plugins.noice = {
      enable = true;
      presets = {
        bottom_search = true;
        command_palette = true;
      };
    };
  };
}
