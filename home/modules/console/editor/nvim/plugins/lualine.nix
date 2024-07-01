{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.editor == "nvim") {
    programs.nixvim.plugins.lualine = {
      enable = true;
      globalstatus = true;
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch"];
        lualine_c = ["filename" "diff"];
        lualine_x = ["diagnostics"];
        lualine_y = ["fileformat"];
        lualine_z = ["filetype"];
      };
    };
  };
}
