{ lib, ... }:

{
  imports = [
    ./obsidian
  ];

  options.homeModules.desktop.productivity = {
    obsidian = {
      enable = lib.mkEnableOption "enable obsidian home module";
    };
  };
}
