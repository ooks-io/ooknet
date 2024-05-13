{ lib, ... }:
{
  imports = [
    ./starship
  ];

  options.homeModules.console.prompt = {
    starship = {
      enable = lib.mkEnableOption "Enable starship prompt";
    };
  };
}
