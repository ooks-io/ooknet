{ lib, config, pkgs, ... }:

let
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
  cfg = config.ooknet.theme.fonts;
in
{
  options.ooknet.theme.fonts = {
    enable = lib.mkEnableOption "Whether to enable font profiles";
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
  };


  config = lib.mkIf cfg.enable {
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

