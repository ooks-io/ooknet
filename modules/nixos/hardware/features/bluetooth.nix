{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem attrValues;
  inherit (config.ooknet.hardware) features;
in {
  config = mkIf (elem "bluetooth" features) {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };

    environment.systemPackages = attrValues {
      #inherit (self.packages.${pkgs.system}) live-buds-cli;
      inherit (pkgs) bluetuith;
    };

    # https://github.com/NixOS/nixpkgs/issues/114222
    systemd.user.services.telephony_client.enable = false;
  };
}
