{ lib, config, pkgs, ... }:

let
  cfg = config.homeModules.desktop.creative.audio.inkscape;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.homeModules.desktop.creative.audio.inkscape.enable = mkEnableOption "Enable inkscape home module";
  config = mkIf cfg.enable {
    home.packages = [ pkgs.inkscape-with-extensions ];
  };
}

