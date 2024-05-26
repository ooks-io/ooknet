{ lib, config, ... }:

let
  inherit (lib) mkIf;
  bootloader = config.systemModules.boot.loader;
in

{
  config = mkIf (bootloader == "systemd") {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
