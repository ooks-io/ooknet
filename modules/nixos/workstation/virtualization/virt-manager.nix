{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "virtualization" profiles) {
    environment.systemPackages = attrValues {
      inherit
        (pkgs)
        virt-viewer
        qemu_kvm
        qemu
        spice
        spice-protocol
        # for windows virtualization
        
        win-virtio
        win-spice
        ;
      # virt-manager needs this
      inherit (pkgs.gnome) adwaita-icon-theme;
    };
    # sets up dconf settins for qemu and add virt-manager to systemPackages
    programs.virt-manager = {
      enable = true;
      package = pkgs.virt-manager;
    };
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
        };
      };
    };
  };
}
