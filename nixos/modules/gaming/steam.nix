{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.gaming.steam;
  steamFix = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
      mangohud
      winetricks
      protontricks
      gtk3
      gtk3-x11
    ];
  };
in

{
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = steamFix;
      extraCompatPackages = [ pkgs.proton-ge-bin.steamcompattool ];
    };
  };
}
