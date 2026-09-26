{
  inputs,
  inputs',
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config.ooknet.host) role admin;
  inherit (config.ooknet.secrets) keys;
  inherit (lib) mkIf mkForce mkDefault;
in {
  imports = [
    # provides a set of packages/modules helpful for installing/repairing a system
    "${nixpkgs}/nixos/modules/profiles/base.nix"
  ];
  config = mkIf (role == "installer") {
    # nixos-anywhere skips kexec when it sees this in os-release
    system.nixos.variant_id = "installer";
    users.users.root = {
      initialHashedPassword = "";
      # install-key, used by ooknet-provision
      openssh.authorizedKeys.keys = [keys.hosts.ooksinstall];
    };
    services.getty.autologinUser = admin.name;
    # installers arent on the tailnet until someone logs in, publish <hostname>.local so
    # ooknet-provision can find them on the lan
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
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
  };
}
