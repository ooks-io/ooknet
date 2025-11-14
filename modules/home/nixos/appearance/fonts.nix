{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (osConfig.ooknet.appearance.fonts) monospace regular;
  inherit (lib) optionals;
in {
  fonts.fontconfig.enable = true;
  home.packages =
    [
      monospace.package
      regular.package

      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.nerd-fonts.symbols-only
    ]
    ++ optionals (monospace.fallback != null) [monospace.fallback.package];
}
