{ lib, ... }:

{
  imports = [
    ./gnomeServices.nix
  ];

  options.systemModules.programs = {
    gnomeServices = {
      enable = lib.mkEnableOption "Enable gnome services module";
    };
  };
}
