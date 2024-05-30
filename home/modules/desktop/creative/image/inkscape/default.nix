{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.desktop.creative.audio.inkscape;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.ooknet.desktop.creative.audio.inkscape.enable = mkEnableOption "Enable inkscape home module";
  config = mkIf cfg.enable {
    home.packages = [ pkgs.inkscape-with-extensions ];
  };
}

