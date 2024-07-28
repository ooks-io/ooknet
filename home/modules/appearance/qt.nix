{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.qt;
in

{
  config = mkIf cfg.enable {
    qt = {
      enable = true;
      style.name = "gtk2"; 
      platformTheme.name = "gtk2";
    };

    home.packages = with pkgs; [
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland
      qt6.qtwayland
      kdePackages.qqc2-desktop-style
      libsForQt5.qtstyleplugins
      qt6Packages.qt6gtk2
    ];
  };
}
