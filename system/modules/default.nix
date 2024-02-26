{ lib, ... }:

{
  imports = [
    ./hardware
    ./bootloader
    ./nix
    ./programs
    ./user
    ./displayManager
    ./networking.nix
    ./locale.nix
    ./virtualisation.nix
    ./pipewire.nix
    ./security.nix
    ./services
    ./ssh.nix
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
