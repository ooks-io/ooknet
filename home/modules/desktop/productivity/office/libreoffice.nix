{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.ooknet.desktop.productivity.office;
in

{
  options.ooknet.desktop.productivity.office.enable = mkEnableOption "enable office home module";
  config = mkIf cfg.enable {
    home.packages = [ pkgs.libreoffice ];
  };
}
