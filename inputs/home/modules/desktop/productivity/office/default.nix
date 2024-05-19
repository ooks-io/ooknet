{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homeModules.desktop.productivity.office;
in

{
  options.homeModules.desktop.productivity.office.enable = mkEnableOption "enable office home module";
  config = mkIf cfg.enable {
    home.packages = [ pkgs.libreoffice ];
  };
}
