{ lib, config, ... }:

let
  cfg = config.systemModules.bootloader;
in

{
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
