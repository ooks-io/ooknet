{
  boot.initrd.luks.devices."cryptnix".device = "/dev/disk/by-uuid/ebb040ca-3c92-445a-acce-94b9e1c774d0";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4b6f64b1-64f2-47c2-b69d-49b441d88b49";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/4b6f64b1-64f2-47c2-b69d-49b441d88b49";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/4b6f64b1-64f2-47c2-b69d-49b441d88b49";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/4b6f64b1-64f2-47c2-b69d-49b441d88b49";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9A75-6622";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 4 * 1024;
    }
  ];
}
