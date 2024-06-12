{ osConfig, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  profiles = osConfig.ooknet.host.profiles;
in

{
  config = mkIf (elem "media" profiles) {
    ooknet.media = {
      image = {
        imv.enable = true;
      };
      video = {
        mpv.enable = true;
        jellyfinPlayer.enable = true;
        youtube.enable = true;
      };
      music = {
        tui.enable = true;
      };
    };
  };
}
