{ lib, config, ... }:

let
  cfg = config.systemProfile.base;
in

{
  config = lib.mkIf cfg.enable {
    systemModules = {
      security.enable = true;
      nixOptions.enable = true;
      pipewire.enable = true;
      networking.enable = true;
      locale.enable = true;
    }
  }; 
}
