{ lib, config, inputs, pkgs, osConfig, ... }:
let 
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
  inherit (lib) mkDefault mkIf;

  monitors = osConfig.ooknet.host.hardware.monitors;
  cfg = config.ooknet.theme.wallpaper;
in
{
  config = mkIf cfg.enable {
    ooknet.theme.wallpaper.path =
      let
        largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
        largestWidth = largest (x: x.width) monitors;
        largestHeight = largest (x: x.height) monitors;
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

