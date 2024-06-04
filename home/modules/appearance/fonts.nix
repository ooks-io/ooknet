{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.fonts;
in

{
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [ 
      cfg.monospace.package
      cfg.regular.package

      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
   ];
  };
}

