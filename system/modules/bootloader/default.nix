{ lib, ... }:

{
  imports = [ ./systemd ./plymouth ];

  options.systemModules = {
    bootloader = {
      systemd = {
        enable = lib.mkEnableOption "Enable systemd bootloader module";
      };
    };
    plymouth = {
      enable = lib.mkEnableOption "Enable plymouth bootscreen";
    };
  };
}
