{
  inputs,
  inputs',
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config.ooknet.host) role admin;
  inherit (lib) mkIf mkForce mkDefault cleanSource;
in {
  imports = [
    # provides a set of packages/modules helpful for installing/repairing a system
    "${nixpkgs}/nixos/modules/profiles/base.nix"
  ];
  config = mkIf (role == "installer") {
    users.users.root.initialHashedPassword = "";
    services.getty.autologinUser = admin.name;
    boot = {
      kernelPackages = mkDefault pkgs.linuxPackages_latest;
      # zfs broken
      supportedFilesystems = mkForce [
        "btrfs"
        "vfat"
        "f2fs"
        "xfs"
        "ntfs"
        "cifs"
      ];
    };
    environment.systemPackages = [
      inputs'.disko.packages.disko
    ];
    isoImage = {
      appendToMenuLabel = " ooknet installer";
      contents = [
        # copy contents of current flake to build initial installation
        {
          source = cleanSource self;
          target = "/ooknet";
        }
      ];
    };
  };
}
