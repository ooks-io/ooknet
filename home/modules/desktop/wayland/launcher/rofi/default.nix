{ lib, config, pkgs, ... }:

let
  cfg = config.homeModules.desktop.wayland.launcher.rofi;
in

{
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      font = "${config.fontProfiles.monospace.family}";
      package = pkgs.rofi-wayland;
    };
  };
  
}
