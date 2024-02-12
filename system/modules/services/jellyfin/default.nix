{ config, lib, pkgs, ... }:

let
  cfg = config.systemModules.services.jellyfin;
in

{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg 
    ];
    services.jellyfin = {
      user = "jellyfin";
      group = "media";
      enable = true;
      openFirewall = true;
    };
    users.users.jellyfin = {
      isSystemUser = true;
      group = "media";
    };
    users.groups.media = {};

    fileSystems."/media" = {
      device = "/dev/disk/by-label/ooksmedia";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" "gid=991" "umask=002" ];
    };
  };
}
