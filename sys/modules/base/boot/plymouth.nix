{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.boot.plymouth;
in

{
  options.systemModules.boot.plymouth.enable = mkEnableOption "";

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
      theme = "catppuccin-mocha";
    };
  };
}
