{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.sys.boot.plymouth;
in

{
  options.sys.boot.plymouth.enable = mkEnableOption "";

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
      theme = "catppuccin-mocha";
    };
  };
}
