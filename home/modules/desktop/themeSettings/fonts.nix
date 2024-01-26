{ pkgs, config, lib,  ... }:
let
  cfg = config.homeModules.desktop.themeSettings;
in
{
  config = lib. mkIf cfg.enable {
    fontProfiles = {
      enable = true;
      monospace = {
        family = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
      regular = {
        family = "Fira Sans";
        package = pkgs.fira;
      };
    };
    home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
    ];
  };
}
