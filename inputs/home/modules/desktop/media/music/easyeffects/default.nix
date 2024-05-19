{lib, config, ... }:

let
  cfg = config.homeModules.desktop.media.music.easyeffects;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.homeModules.desktop.media.music.easyeffects.enable = mkEnableOption "Enable easy effects home module";
  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
    };
  };
}
