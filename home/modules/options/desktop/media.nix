{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.media = {
    image = {
      imv.enable = mkEnableOption "";
    };
    video = {
      mpv.enable = mkEnableOption "";
      jellyfinPlayer.enable = mkEnableOption "";
      youtube.enable = mkEnableOption "";
    };
    music = {
      tui.enable = mkEnableOption "";
    };
  };
}
