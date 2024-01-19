{ lib, ... }:

{
  imports = [ ./systemd ];

  options.systemModules = {
    bootloader = {
      systemd = {
        enable = lib.mkEnableOption "Enable systemd bootloader module";
      };
    };
  };
}
