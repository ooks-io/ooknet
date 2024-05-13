{ lib, ... }:
{
  imports = [
    ./fish
    ./bash
  ];

  options.homeModules.console.shell = {
    fish = {
      enable = lib.mkEnableOption "Enable fish configuration";
    };
    bash = {
      enable = lib.mkEnableOption "Enable bash configuration";
    };
    zsh = {
      enable = lib.mkEnableOption "Enable zsh configuration";
    };
  };
}
