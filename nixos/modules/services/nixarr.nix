{ config, inputs, lib, ... }:

let
  inherit (lib) mkIf;
  admin = config.ooknet.host.admin;
  cfg = config.ooknet.services.nixarr;
in
  
{
  imports = [ inputs.nixarr.nixosModules.default ];
  config = mkIf cfg.enable {
    nixarr = {
      enable = true;
      mediaDir = "/jellyfin";
      stateDir = "/var/lib/nixarr";
      mediaUsers = ["${admin.name}"];

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
