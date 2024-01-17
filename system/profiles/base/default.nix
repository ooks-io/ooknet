{ inputs, outputs, lib, config, pkgs, ... }:

let
  cfg = config.systemProfile.base;
in

{

  imports = [
    ../modules
    inputs.home-manager.nixosModules.home-manager
  ];
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.git];
    environment.enableAllTerminfo = true;
    systemModules = {
      security.enable = true;
      nixOptions.enable = true;
      pipewire.enable = true;
      networking.enable = true;
      locale.enable = true;
    };

    home-manager.extraSpecialArgs = { inherit inputs outputs; };
    hardware.enableAllFirmware = true;
  }; 
}
