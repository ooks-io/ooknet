{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str enum bool package;
in {
  options.ooknet.host = {
    name = mkOption {
      type = str;
      default = "ooks-generic";
    };
    type = mkOption {
      type = enum ["vm" "desktop" "laptop"];
    };
    role = mkOption {
      type = enum ["workstation" "server"];
    };

    syncthing = {
      enable = mkEnableOption "Enable syncthing";
    };

    boot = {
      loader = mkOption {
        type = enum ["systemd" "grub"];
        default = "systemd";
      };
      kernel = mkOption {
        type = package;
        default = pkgs.linuxPackages_latest;
      };
    };
    exitNode = mkOption {
      type = bool;
      default = false;
    };

    admin = {
      name = mkOption {
        type = str;
        default = "ooks";
      };
      shell = mkOption {
        type = enum ["bash" "zsh" "fish"];
        default = "fish";
      };
      gitName = mkOption {
        type = str;
        default = "ooks-io";
      };
      gitEmail = mkOption {
        type = str;
        default = "ooks@protonmail.com";
      };
      email = mkOption {
        type = str;
        default = "ooks@protonmail.com";
      };
      homeManager = mkOption {
        type = bool;
        default = false;
        description = ''
          Home-manager is enabled if ooknet.host.role == "workstation".
          If host is not a workstation and you would like to enable home-manager
          enable this option.
        '';
      };
    };
  };
}
