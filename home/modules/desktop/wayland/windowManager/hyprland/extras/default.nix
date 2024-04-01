{ lib, ... }:

{
  imports = [
    ./hyprcapture
    ./hyprshade
  ];

  options.homeModules.desktop.wayland.windowManager.hyprland.extras = {
    hyprcapture = {
      enable = lib.mkEnableOption "Enable hyprcapture screenshot/recording module";
    };
    hyprshade = {
      enable = lib.mkEnableOption "Enable hyprshade tool module";
    };
  };
}
