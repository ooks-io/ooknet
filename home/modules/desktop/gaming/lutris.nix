{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.gaming.lutris;
in

{
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
