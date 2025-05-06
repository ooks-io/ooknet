{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.virtualiazation) guest;
in {
  config = mkIf (guest.enable && guest.type == "qemu") {
    services.qemuGuest.enable = true;
    boot.initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };
  };
}
