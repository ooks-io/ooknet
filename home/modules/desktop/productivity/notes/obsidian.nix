{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.ooknet.productivity.notes.obsidian;
  notes = config.ooknet.desktop.notes;
in

{
  options.ooknet.productivity.notes.obsidian.enable = mkEnableOption "";
  config = mkIf (cfg.enable || notes == "obsidian") {
    home.packages = [ pkgs.obsidian ];
    
  };
}
