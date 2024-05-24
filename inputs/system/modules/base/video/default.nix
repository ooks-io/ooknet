{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
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
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
    };
  };
}
