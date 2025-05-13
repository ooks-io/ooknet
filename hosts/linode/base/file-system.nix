{
  fileSystems."/" = {
    device = "/dev/sda";
    fsType = "ext4";
    autoResize = true;
  };
  swapDevices = [{device = "/dev/sdb";}];
}
