{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.ooknet.desktop.wayland.launcher.anyrun;
in

{
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];
  
  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          randr
          shell
          rink
          symbols
        ];
      };
      extraCss = /* css */ ''

        * {
          font-family: JetBrains Mono Nerd Font;
        }
        
      '';
    };
  };
  
}
