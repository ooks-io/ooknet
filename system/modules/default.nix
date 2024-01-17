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
