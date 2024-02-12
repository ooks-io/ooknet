{ config, lib, pkgs, ... }:

let
  cfg = config.systemModules.services.deluge;
in

{
  config = lib.mkIf cfg.enable {
    services.deluge = {
      user = "deluge";
      group = "deluge";
      enable = true;
      web.enable = true;
    };

    # fileSystems."/media/Downloads" = {
    #   device = "/dev/disk/by-label/torrents";
    #   fsType = "ext4";
    #   options = [ "rw" "uid=1000" "gid=991" "umask=002" ];
    # };
  };
}
