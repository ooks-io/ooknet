{ pkgs, lib, config, ... }:
let
  cfg = config.homeModules.desktop.media.video.jellyfin;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ jellyfin-media-player ];
  };
}
