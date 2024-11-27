{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/50617edf-e788-49cc-9e0c-85a2f90a5550";
      fsType = "btrfs";
      options = ["subvol=root"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/50617edf-e788-49cc-9e0c-85a2f90a5550";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/50617edf-e788-49cc-9e0c-85a2f90a5550";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };
    "/swap" = {
      device = "/dev/disk/by-uuid/50617edf-e788-49cc-9e0c-85a2f90a5550";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B511-09E2";
      fsType = "vfat";
    };
    "/media-server" = {
      device = "/dev/disk/by-label/jellyfin";
      fsType = "btrfs";
    };
  };
  swapDevices = [];
}
