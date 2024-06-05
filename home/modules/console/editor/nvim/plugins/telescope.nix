{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.nixvim = {
      plugins.telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          frecency.enable = true;
        };

        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>b" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fd" = "diagnostics";

          "<C-p>" = "git_files";
          "<leader>p" = "oldfiles";
          "<C-f>" = "live_grep";
        };

        keymapsSilent = true;

        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^data/"
          ];
          set_env.COLORTERM = "truecolor";
        };
      };
    };
  };
}
