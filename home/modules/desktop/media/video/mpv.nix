{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.media.video.mpv;
in

{
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
    };
  };
}
