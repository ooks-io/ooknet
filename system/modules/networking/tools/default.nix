{ lib, config, pkgs, ... }:

let
  cfg = config.systemModules.networking;
  inherit (lib) mkIf mkEnableOption;
in

{
  options.systemModules.networking.tools = mkEnableOption "Enable networking tools";

  config = mkIf cfg.tools {
    environment.systemPackages = with pkgs; [
      traceroute
      mtr
      tcpdump
    ];
  };
}
