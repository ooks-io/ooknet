{ lib, ... }:

{
  imports = [
    ./gnomeServices.nix
    ./dconf
  ];

  options.systemModules.programs = {
    gnomeServices = {
      enable = lib.mkEnableOption "Enable gnome services module";
    };
  };
}
