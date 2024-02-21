{ lib, config, inputs, ... }:

let
  cfg = config.homeModules.desktop.wayland.lockscreen.hyprlock;
  inherit (config.colorscheme) colors;
in

{
  imports = [ inputs.hyprlock.homeManagerModules.hyprlock ];

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
    };
  };

  
}
