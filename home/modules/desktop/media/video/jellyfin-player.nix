{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.media.video.jellyfinPlayer;
in

{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.jellyfin-media-player ];
  };
}
