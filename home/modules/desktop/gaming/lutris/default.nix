{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homeModules.desktop.gaming.lutris;
in

{
  options.homeModules.desktop.gaming.lutris.enable = mkEnableOption "Enable lutris home-manager module";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (lutris.override {
        extraPkgs = p: [
          p.pixman
          p.libjpeg
          p.gnome.zenity
          p.gamescope
        ];
      })
      winetricks
    ];
  };
}
