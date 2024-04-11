{ lib, ... }:

{
  imports = [
    ./hardware
    ./bootloader
    ./nix
    ./programs
    ./user
    ./displayManager
    ./networking
    ./locale
    ./virtualisation
    ./security
    ./services
    ./audio
  ];


  options.systemModules = {
    security = {
      enable = lib.mkEnableOption "Enable security module";
    };
    pipewire = {
      enable = lib.mkEnableOption "Enable pipewire module";
    };
    networking = {
      enable = lib.mkEnableOption "Enable networking module";
    };
    virtualisation = {
      enable = lib.mkEnableOption "Enable virtualisation module";
    };
    locale = {
      enable = lib.mkEnableOption "Enable locale module";
    };
  };
}
