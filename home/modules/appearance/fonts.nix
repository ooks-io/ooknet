{
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig.ooknet.appearance.fonts) monospace regular;
in {
  fonts.fontconfig.enable = true;
  home.packages = [
    monospace.package
    regular.package

    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
  ];
}
