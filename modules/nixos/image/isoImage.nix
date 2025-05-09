{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) mkIf;
  inherit (config.ooknet.host) type;
  inherit (config.ooknet.secrets) keys;
in {
  imports = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

    # ensure we have we have an initial copy of the nixos channel
    "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  config = mkIf (type == "iso") {
    isoImage = {
      makeEfiBootable = true;
      makeUsbBootable = true;
      edition = config.networking.hostName;
    };

    hardware = {
      enableAllHardware = true;
      enableRedistributableFirmware = true;
    };

    users.users.root.openssh.authorizedKeys.keys = [keys.hosts.ooksinstall];

    boot.loader.grub.memtest86.enable = true;
    system.switch.enable = false;
  };
}
