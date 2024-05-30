{ lib, ... }:

{
  imports = [
    ./obsidian
    ./zathura
    ./office
  ];

  options.ooknet.desktop.productivity = {
    obsidian = {
      enable = lib.mkEnableOption "enable obsidian home module";
    };
    zathura = {
      enable = lib.mkEnableOption "enable zathura home module";
    };
  };
}
