# pi5 boots straight from eeprom firmware, no u-boot. vendor kernel + its own
# dtbs/overlays, same as raspberry pi os and nvmd/nixos-raspberrypi.
# single generation, rollback = rebuild the old config
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.boot.kernelPackages) kernel;
  inherit (config.system.boot.loader) kernelFile;
  inherit (builtins) attrValues;

  # vendor kernel isnt cached anywhere and emulated builds take hours, so
  # cross compile it from x86. means the kernel only builds on ooksdesk
  crossPkgs = import pkgs.path {
    localSystem = "x86_64-linux";
    crossSystem = pkgs.stdenv.hostPlatform.system;
  };

  # nixpkgs linux_rpi4 with the pi5 defconfig, what nixos-raspberrypi does for linux_rpi5
  linux_rpi5 = crossPkgs.callPackage "${pkgs.path}/pkgs/os-specific/linux/kernel/linux-rpi.nix" {
    kernelPatches = attrValues {
      inherit (crossPkgs.kernelPatches) bridge_stp_helper request_key_helper;
    };
    rpiVersion = 4;
    argsOverride.defconfig = "bcm2712_defconfig";
  };

  # raspberry pi os defaults
  configTxt = pkgs.writeText "config.txt" ''
    [all]
    arm_64bit=1
    kernel=kernel.img
    initramfs initrd followkernel
    camera_auto_detect=1
    display_auto_detect=1
    max_framebuffers=2
    disable_fw_kms_setup=1
    disable_overscan=1
    arm_boost=1
    enable_uart=1
    dtparam=audio=on
    dtoverlay=vc4-kms-v3d

    # pi5 has a dedicated debug uart, the mini uart feeds ghost input into boot
    [pi5]
    enable_uart=0

    # host extras, reset the filter so they dont land under [pi5]
    [all]
    ${config.ooknet.hardware.rpi5.configTxt}
  '';

  # $1 toplevel, $2 firmware dir (sdImage passes its staging dir)
  # runtimeInputs sets PATH, switch-to-configuration runs this under
  # systemd-run with no coreutils on PATH otherwise
  populate = pkgs.writeShellApplication {
    name = "pi5-populate";
    runtimeInputs = [pkgs.coreutils];
    text = ''
      top=$(readlink -f "$1")
      dir=''${2:-/boot/firmware}
      dtbs=${kernel}/dtbs

      put() { cp "$1" "$2.tmp" && mv "$2.tmp" "$2"; }

      put ${configTxt} "$dir/config.txt"
      put "$top/kernel" "$dir/kernel.img"
      put "$top/initrd" "$dir/initrd"
      for dtb in "$dtbs"/broadcom/bcm2712*.dtb; do
        put "$dtb" "$dir/$(basename "$dtb")"
      done
      mkdir -p "$dir/overlays"
      for ovr in "$dtbs"/overlays/*; do
        put "$ovr" "$dir/overlays/$(basename "$ovr")"
      done
      echo "$(cat "$top/kernel-params") init=$top/init" > "$dir/cmdline.txt.tmp"
      mv "$dir/cmdline.txt.tmp" "$dir/cmdline.txt"
      sync
    '';
  };
in {
  boot = {
    kernelPackages = crossPkgs.linuxPackagesFor linux_rpi5;
    kernelParams = [
      "console=serial0,115200"
      "console=tty1"
      "rootwait"
    ];
    # from nixos-hardware raspberry-pi/5, vc4 gets us an early hdmi console
    initrd.availableKernelModules = ["nvme" "pcie-brcmstb" "clk-rp1" "rp1" "usb-storage" "usbhid" "vc4"];

    loader = {
      grub.enable = false;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = false;
      external = {
        enable = true;
        installHook = lib.getExe populate;
      };
    };
  };

  # sd-image turns this on for generic boards, it asks the initrd for
  # rockchip/allwinner modules the vendor kernel doesnt build
  hardware.enableAllHardware = lib.mkForce false;

  # no tpm on the pi, and tpm-crb isnt in the vendor kernel
  boot.initrd.systemd.tpm2.enable = false;
  systemd.tpm2.enable = false;

  # pi5 kernel is Image, sanity check in case nixpkgs changes it
  assertions = [
    {
      assertion = kernelFile == "Image";
      message = "rpi5 boot expects an uncompressed arm64 Image";
    }
  ];
}
