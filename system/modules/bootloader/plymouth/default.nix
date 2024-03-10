{ lib, config, pkgs, ... }:

let
  cfg = config.systemModules.plymouth;
in

{
  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
      theme = "catppuccin-mocha";
    };
  };
}
