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
    ./meta
    ./host
    ./video
  ];


  options.systemModules = {
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
