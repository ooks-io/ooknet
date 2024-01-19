{ config, lib, pkgs, ... }:

let
  cfg = config.systemModules.hardware.bluetooth;
in

{
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };
  
    environment.systemPackages = with pkgs; [
    	galaxy-buds-client
      live-buds-cli
  	  bluetuith
  	];

     # https://github.com/NixOS/nixpkgs/issues/114222
    systemd.user.services.telephony_client.enable = false;
  };
}
