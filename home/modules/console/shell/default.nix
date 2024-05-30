{ lib, ... }:
{
  imports = [
    ./fish
    ./bash
    ./zsh
  ];

  options.ooknet.console.shell = {
    fish = {
      enable = lib.mkEnableOption "Enable fish configuration";
    };
    bash = {
      enable = lib.mkEnableOption "Enable bash configuration";
    };
  };
}
