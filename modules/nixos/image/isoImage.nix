{
  inputs,
  lib,
  config,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) mkIf cleanSource;
  inherit (config.ooknet.host) type;
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
      appendToMenuLabel = " ooknet installer";
      contents = [
        # copy contents of current flake to build initial installation
        {
          source = cleanSource self;
          target = "/ooknet";
        }
      ];
    };

    hardware = {
      enableAllHardware = true;
      enableRedistributableFirmware = true;
    };

    boot.loader.grub.memtest86.enable = true;
    system.switch.enable = false;
  };
}
