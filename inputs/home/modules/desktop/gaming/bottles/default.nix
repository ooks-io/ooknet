{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homeModules.desktop.gaming.bottles;
in

{
  options.homeModules.desktop.gaming.bottles.enable = mkEnableOption "Enable bottles home-manager modules";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles
    ];
  };
  
}
