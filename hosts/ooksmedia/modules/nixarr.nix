{ config, lib, ... }:

let
  inherit (lib) mkIf;
  admin = config.ooknet.host.admin;
  cfg = config.ooknet.services.nixarr;
in
  
{
  config = mkIf cfg.enable {
    nixarr = {
      vpn.enable = false;
      openssh.expose.vpn.enable = false;
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
