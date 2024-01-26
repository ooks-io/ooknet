{ pkgs, config, lib, ... }:

let
  cfg = config.homeModules.desktop.media.music.tui;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      termusic
      spotify-player
      ytui-music
      alsa-utils
    ];
  };
  
}
