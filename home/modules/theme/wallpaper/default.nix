{ lib, config, inputs, pkgs, ... }:
let 
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
  inherit (lib) types mkDefault mkIf mkOption mkEnableOption;

  cfg = config.homeModules.theme.wallpaper;
in
{
  options.homeModules.theme.wallpaper = {
    enable = mkEnableOption "Enable wallpaper module";
    path = mkOption {
      type = types.path;
      default = null;
      description = "Wallpaper Path";
    };
  };

  config = mkIf cfg.enable {
    homeModules.theme.wallpaper.path =
      let
        largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
        largestWidth = largest (x: x.width) config.monitors;
        largestHeight = largest (x: x.height) config.monitors;
      in
      mkDefault (nixWallpaperFromScheme
        {
          scheme = config.colorscheme;
          width = largestWidth;
          height = largestHeight;
          logoScale = 4;
        });
  };
}

