{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.desktop.productivity.obsidian;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];
  };
}
