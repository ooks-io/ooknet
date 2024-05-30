{ lib, ... }:

{
  imports = [
    ./hyprland
  ];

  options.ooknet.desktop.wayland.windowManager = { 
    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland window-manager";
    };
  };

}
