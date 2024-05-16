{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;
  host = config.systemModules.host;
in

{
  config = mkIf (host.type != "phone") {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = isx86Linux pkgs;
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
    };
  };
}
