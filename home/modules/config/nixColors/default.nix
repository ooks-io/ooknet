{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.homeModules.config.nixColors;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
in

{
  imports = [ inputs.nix-colors.homeManagerModule ];

  config = lib.mkIf cfg.enable {
    colorscheme = lib.mkDefault colorSchemes.gruvbox-material-dark-soft;
    home.file.".colorscheme".text = config.colorscheme.slug;

    wallpaper =
      let
        largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
        largestWidth = largest (x: x.width) config.monitors;
        largestHeight = largest (x: x.height) config.monitors;
      in
      lib.mkDefault (nixWallpaperFromScheme
        {
          scheme = config.colorscheme;
          width = largestWidth;
          height = largestHeight;
          logoScale = 4;
        });
  };
}
