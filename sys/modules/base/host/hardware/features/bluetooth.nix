{ config, lib, pkgs, self, ... }:

let
  features = config.systemModules.host.hardware.features;
  inherit (lib) mkIf;
  inherit (builtins) elem;
in

{
  config = mkIf (elem "bluetooth" features) {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };
  
    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.system}.live-buds-cli
  	  bluetuith
  	];

    # https://github.com/NixOS/nixpkgs/issues/114222
    systemd.user.services.telephony_client.enable = false;
  };
}
