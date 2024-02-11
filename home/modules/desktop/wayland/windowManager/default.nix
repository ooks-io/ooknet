{ lib, ... }:

{
  imports = [
    ./hyprland
  ];

  options.homeModules.desktop.wayland.windowManager = { 
    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland window-manager";
      nvidia = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Apply Hyprland nvidia settings";
      };
    };
  };

}
