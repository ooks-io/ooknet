{ lib, ... }:

{
  imports = [
    ./hyprland
  ];

  options.homeModules.desktop.wayland.windowManager = { 
    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland window-manager";
    };
  };

}
