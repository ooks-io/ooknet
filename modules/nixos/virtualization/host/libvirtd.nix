{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.virtualization.host;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      # allow unprivileged users to pass usb devices to vm
      spiceUSBRedirection.enable = true;

      # our virtualization daemon
      libvirtd = {
        enable = true;

        qemu = {
          # by default this uses pkgs.qemu but since i do not need to emulate aarch64 currently i use
          # qemu_kvm which only supports the hosts system architecture.
          package = pkgs.qemu_kvm;

          # for emulating TPM
          swtpm.enable = true;

          # UEFI secure boot
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
          # ensure virtiofsd is accessible to all domains
          vhostUserPackages = [pkgs.virtiofsd];
        };
      };
    };
  };
}
