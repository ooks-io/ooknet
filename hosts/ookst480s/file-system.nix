{
  boot.initrd.luks.devices."cryptnix".device = "/dev/disk/by-uuid/014d725c-bf13-40a2-a9ab-0dd6185a95f6";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/19e4cf0f-b5ac-4544-a44b-c017b23fd283";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/19e4cf0f-b5ac-4544-a44b-c017b23fd283";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/19e4cf0f-b5ac-4544-a44b-c017b23fd283";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/19e4cf0f-b5ac-4544-a44b-c017b23fd283";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/F356-6F9C";
      fsType = "vfat";
    };
  };
  swapDevices = [];
}
