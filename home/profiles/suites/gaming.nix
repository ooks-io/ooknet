{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.gaming;
in
{

  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    homeModules.desktop = {
      gaming = {
        lutris.enable = false;
      };
    };
    home.packages = with pkgs; [
      bottles
      winetricks
      protontricks
      protonup-qt
      wineWowPackages.full
    ];
  };
}
