{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.productivity.notes.obsidian;
  notes = config.ooknet.desktop.notes;
in

{
  config = mkIf (cfg.enable || notes == "obsidian") {
    home.packages = [ pkgs.obsidian ];
    ooknet.binds.notes = mkIf (notes == "obsidian") "obsidian";
  };
}
