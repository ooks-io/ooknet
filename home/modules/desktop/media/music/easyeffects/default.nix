{lib, config, ... }:

let
  cfg = config.ooknet.desktop.media.music.easyeffects;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.ooknet.desktop.media.music.easyeffects.enable = mkEnableOption "Enable easy effects home module";
  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
    };
  };
}
