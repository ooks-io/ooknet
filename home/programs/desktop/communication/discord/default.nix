{ lib, config, pkgs, ... }: 

let
  cfg = config.programs.desktop.communication.discord;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vesktop ];
  };
}
