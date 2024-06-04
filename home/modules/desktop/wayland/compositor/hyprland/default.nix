{ lib, config, pkgs, inputs, ... }: 
let
  wayland = config.ooknet.wayland;
  inherit (import ./pkgs {inherit pkgs;}) hyprbrightness hyprvolume;
  inherit (inputs.ooks-scripts.packages.${pkgs.system}) powermenu zellijmenu;
  inherit (lib) mkIf;
in
{
  imports = [
    # inputs.hyprland.homeManagerModules.default
    ./settings
    ./extras
  ];

  config = mkIf (wayland.compositor == "hyprland") {
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
