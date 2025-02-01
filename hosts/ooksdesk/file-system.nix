{
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/b5d09a8b-54a9-4f72-828c-5cceea2ec287";
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/629a7421-24a0-45e6-87af-031574d9d46d";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/629a7421-24a0-45e6-87af-031574d9d46d";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/629a7421-24a0-45e6-87af-031574d9d46d";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/629a7421-24a0-45e6-87af-031574d9d46d";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1D01-7040";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024;
    }
  ];
}
