{
  config,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  # sd-image defaults to noauto, automount so the bootloader hook can write to it
  fileSystems."/boot/firmware".options = lib.mkForce [
    "noatime"
    "noauto"
    "x-systemd.automount"
    "x-systemd.idle-timeout=1min"
  ];
  fileSystems."/".options = ["noatime"];

  sdImage = {
    compressImage = false;
    # kernel + initrd live on the firmware partition, default 30M is too small
    firmwareSize = 256;
    # bootloader hook takes a target dir, point it at the image staging dir
    populateFirmwareCommands = ''
      ${config.system.build.installBootLoader} ${config.system.build.toplevel} firmware
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot/firmware
    '';
  };
}
