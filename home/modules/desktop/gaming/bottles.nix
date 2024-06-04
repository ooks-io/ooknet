{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.gaming.bottles;
in

{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles
    ];
  };
  
}
