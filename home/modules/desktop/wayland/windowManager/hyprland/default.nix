{ lib, config, pkgs, inputs, ... }: 
let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
  inherit (import ./pkgs {inherit pkgs;}) hyprbrightness hyprvolume hyprkillsession;
  inherit (inputs.ooks-scripts.packages.${pkgs.system}) hyprrecord powermenu zellijmenu;
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

      # Personal scripts
      hyprrecord
      powermenu
      zellijmenu #TODO: only add if zellij enabled
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
