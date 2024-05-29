{ lib, config, pkgs, inputs, ... }: 
let
  cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
  inherit (import ./pkgs {inherit pkgs;}) hyprbrightness hyprvolume;
  inherit (inputs.ooks-scripts.packages.${pkgs.system}) powermenu zellijmenu;
in
{
  imports = [
    # inputs.hyprland.homeManagerModules.default
    ./settings
    ./extras
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.hyprpicker
      hyprvolume
      hyprbrightness

      # Personal scripts
      powermenu
      zellijmenu #TODO: only add if zellij enabled
      ];
    
    wayland.windowManager.hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
  };
}
