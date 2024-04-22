{ lib, config, ... }:

let
  cfg = config.systemModules.networking;
  inherit (lib) mkIf mkEnableOption;
in

{
  imports = [
    ./firewall
    ./tools
    ./ssh
    ./tcp
    ./resolved
    ./tailscale
  ];

  options.systemModule.networking.enable = mkEnableOption "Enable networking system module";

  config = mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    systemd = {
      network.wait-online.enable = false;
      services.NetworkManager-wait-online.enable = false;
    };
  };
}
