{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge;
  cfg = config.ooknet.productivity.notes.obsidian;
  notes = config.ooknet.desktop.notes;
in

{
  config = mkMerge [ 
    (mkIf (cfg.enable || notes == "obsidian") {
      home.packages = [ pkgs.obsidian ];
    })

    (mkIf (notes == "obsidian") {
      ooknet.binds.notes = "obsidian";
    })
  ];
}
