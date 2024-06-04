{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.gaming.factorio;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ factorio ];
  };
}
