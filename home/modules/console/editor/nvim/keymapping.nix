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

      keymaps = let
        normal = 
          mapAttrsToList
          (key: action: {
            mode = "n";
            inherit action key;
          })
          {
            "<Space>" = "<NOP>";
            "esc" = ":noh<CR>";
            "Y" = "$y";
          };
          visual =
            mapAttrsToList
            (key: action: {
              mode = "v";
              inherit action key;
            })
            {
              # better indenting
              ">" = ">gv";
              "<" = "<gv";
              "<TAB>" = ">gv";
              "<S-TAB>" = "<gv";

              # move selected line / block of text in visual mode
              "K" = ":m '<-2<CR>gv=gv";
              "J" = ":m '>+1<CR>gv=gv";
            };
      in
      config.nixvim.helpers.keymaps.mkKeymaps
      {options.silent = true;}
      (normal ++ visual);
    };
  };
}
