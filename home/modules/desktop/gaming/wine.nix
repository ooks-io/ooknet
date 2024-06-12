{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.gaming.wine;
in

{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      winetricks
      protontricks
      protonup-qt
      wineWowPackages.waylandFull
    ];
  };
}
