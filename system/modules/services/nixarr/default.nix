{ lib, config, inputs, ... }:

let
  cfg = config.systemModules.services.nixarr;
  inherit (lib) mkEnableOption mkIf;
in

{
  options.systemModules.services.nixarr.enable = mkEnableOption "Enable nixarr module";

  imports = [ inputs.nixarr.nixosModules.default ];

  config = mkIf cfg.enable {
    nixarr = {
      enable = true;
      mediaDir = "/jellyfin";
      stateDir = "/var/lib/nixarr";
      mediaUsers = ["ooks"];

      jellyfin.enable = true;
      sonarr.enable = true;
      radarr.enable = true;
      prowlarr.enable = true;
      transmission.enable = true;
    };
    fileSystems."/jellyfin" = {
      device = "/dev/disk/by-label/jellyfin";
      fsType = "btrfs";
    };
  };
}
