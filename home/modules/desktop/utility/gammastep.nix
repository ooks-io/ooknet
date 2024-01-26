{ lib, config, ... }:

let
  cfg = config.homeModules.desktop.utility.gammastep;
in

{
  config = lib.mkIf cfg.enable {
    services.gammastep = lib.mkif config.programs.desktop.windowManager.hyprland.enable {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 6000;
        night = 4600;
      };
      settings = {
        general.adjustment-method = "wayland";
      };
    };
  };
}
