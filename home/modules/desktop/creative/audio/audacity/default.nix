{ lib, config, pkgs, ... }:

let
  cfg = config.ooknet.desktop.creative.audio.audacity;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.ooknet.desktop.creative.audio.audacity.enable = mkEnableOption "Enable audacity home module";
  config = mkIf cfg.enable {
    home.packages = [ pkgs.audacity ];
  };
}
