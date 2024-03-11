{ lib, config, pkgs, inputs, ... }: 
let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
  inherit (import ./pkgs {inherit pkgs;}) hyprrecord hyprbrightness hyprvolume hyprkillsession;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./settings
  ];

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      extraPortals = [ pkgs.inputs.hyprland.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.inputs.hyprland.hyprland ];
    };

    home.packages = [
      inputs.hyprwm-contrib.packages.${pkgs.system}.grimblast
      pkgs.hyprshade
      pkgs.hyprpicker
      hyprvolume
      hyprkillsession
      hyprbrightness
      hyprrecord
    ];
    
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
  };
}
