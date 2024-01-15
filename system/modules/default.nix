{ lib, ... }:

{
  imports = [
    ./hardware
    ./networking
    ./nix
    ./programs
    ./user
  ];


  options.systemModules = {
    security = {
      enable = lib.mkEnableOption "Enable security module";
    };
    bootloader = {
      enable = lib.mkEnableOption "Enable systemd bootloader module";
    };
    pipewire = {
      enable = lib.mkEnableOption "Enable pipewire module";
    };
  };
}
