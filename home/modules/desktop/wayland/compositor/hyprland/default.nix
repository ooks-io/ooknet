{ lib, config, pkgs, ... }: 
let
  wayland = config.ooknet.wayland;
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
