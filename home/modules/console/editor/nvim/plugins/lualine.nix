{ config, lib, ... }:

let
  cfg = config.ooknet.console.editor.nvim.plugins;
in

{
  config = lib.mkIf cfg.lualine {
    programs.nixvim.plugins.lualine = {
      enable = true;
      theme = "base16";
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
