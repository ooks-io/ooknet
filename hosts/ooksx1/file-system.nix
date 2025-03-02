{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5220a8c9-8a58-48d1-9119-9336a67542e2";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/29FF-35B3";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };
  swapDevices = [
    {device = "/dev/disk/by-uuid/69bd9dce-c7df-4a33-add7-97d4886a3bc0";}
  ];
}
