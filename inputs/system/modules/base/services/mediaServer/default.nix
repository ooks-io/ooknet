{ config, lib, pkgs, ... }:

let
  cfg = config.systemModules.services.mediaServer;
in

{
  config = lib.mkIf cfg.enable {

    users.groups.media = { };

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg 
    ];

    services = {
      jellyfin = {
        group = "media";
        enable = true;
        openFirewall = true;
      };
      deluge = {
        group = "media";
        enable = true;
        web.enable = true;
      };
      radarr = {
        group = "media";
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        group = "media";
        enable = true;
        openFirewall = true;
      };
      prowlarr.enable = true;
    };

    systemd.tmpfiles.rules = [
      "d /jellyfin 0770 - media - -"
    ];

    fileSystems."/jellyfin" = {
      device = "/dev/disk/by-label/jellyfin";
      fsType = "btrfs";
    };
  };
}
