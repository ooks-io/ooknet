{ inputs, ... }:
  
  
{
  imports = [ inputs.nixarr.nixosModules.default ];
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
}
