{ config, lib, ... }:

let
  cfg = config.homeModules.desktop.wayland.bar.waybar;
in

{
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
  };
}
